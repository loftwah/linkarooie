# lib/tasks/migrate_images_to_spaces.rake

namespace :images do
  desc 'Migrate user avatars and banners to DigitalOcean Spaces (use dry_run=true for testing)'
  task :migrate_to_spaces, [:dry_run] => :environment do |t, args|
    dry_run = args[:dry_run] == 'true'
    puts "\n#{'DRY RUN: ' if dry_run}Starting image migration to DigitalOcean Spaces"
    puts "=========================================================\n\n"

    unless ENV['SPACES_BUCKET_CONTENT']
      puts "Error: SPACES_BUCKET_CONTENT environment variable is not set."
      exit
    end

    def upload_to_spaces(file_path, key, dry_run)
      if dry_run
        puts "  Would upload: #{file_path}"
        puts "           To: #{key}"
        "https://#{ENV['SPACES_BUCKET_CONTENT']}.syd1.digitaloceanspaces.com/#{key}"
      else
        bucket = S3_CLIENT.bucket(ENV['SPACES_BUCKET_CONTENT'])
        obj = bucket.object(key)
        
        begin
          File.open(file_path, 'rb') do |file|
            obj.put(body: file, acl: 'public-read')
          end
          puts "  Uploaded: #{key}"
          "https://#{ENV['SPACES_BUCKET_CONTENT']}.syd1.digitaloceanspaces.com/#{key}"
        rescue Aws::S3::Errors::ServiceError => e
          puts "  Failed to upload #{key}: #{e.message}"
          nil
        end
      end
    end

    def migrate_image(user, attribute, folder, dry_run)
      local_path = user.send("#{attribute}_local_path") || user.send(attribute)
      if local_path.present?
        file_path = local_path.start_with?('/') ? Rails.root.join('public', local_path.sub(/\A\//, '')) : Rails.root.join('public', local_path)
        if File.exist?(file_path)
          key = "#{folder}/#{user.id}_#{File.basename(file_path)}"
          spaces_url = upload_to_spaces(file_path, key, dry_run)
          if spaces_url
            if dry_run
              puts "  Would update #{attribute} URL to: #{spaces_url}"
            else
              user.update(attribute => spaces_url)
              puts "  Updated #{attribute} URL to: #{spaces_url}"
            end
          end
        else
          puts "  File not found: #{file_path}"
        end
      else
        puts "  No #{attribute} found"
      end
    end

    puts "Migrating user images:"
    User.find_each do |user|
      puts "\nProcessing user: #{user.email}"
      puts "  Avatar:"
      migrate_image(user, :avatar, 'avatars', dry_run)
      puts "  Banner:"
      migrate_image(user, :banner, 'banners', dry_run)
    end

    def handle_default_image(image_type, dry_run)
      puts "\nProcessing default #{image_type}:"
      fallback_constant = "User::FALLBACK_#{image_type.upcase}_URL"
      fallback_url = User.const_get(fallback_constant)
      file_path = Rails.root.join('public', fallback_url.sub(/\A\//, ''))

      if File.exist?(file_path)
        key = "defaults/default_#{image_type}#{File.extname(file_path)}"
        spaces_url = upload_to_spaces(file_path, key, dry_run)
        if spaces_url
          affected_users = User.where(image_type => fallback_url)
          if dry_run
            puts "  Would update #{affected_users.count} users with default #{image_type}"
            puts "  New URL would be: #{spaces_url}"
          else
            affected_users.update_all(image_type => spaces_url)
            puts "  Updated #{affected_users.count} users' default #{image_type}"
            puts "  New URL is: #{spaces_url}"
          end
        end
      else
        puts "  Default #{image_type} file not found: #{file_path}"
      end
    end

    handle_default_image('avatar', dry_run)
    handle_default_image('banner', dry_run)

    puts "\n#{'DRY RUN: ' if dry_run}Image migration completed!"
    puts "=========================================================\n\n"
  end
end