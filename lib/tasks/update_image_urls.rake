namespace :users do
  desc 'Update user avatar and banner URLs to use correct DigitalOcean Spaces URLs with proper extensions'
  task update_image_urls: :environment do
    puts "Updating user image URLs..."

    def fetch_content_type(url)
      uri = URI.parse(url)
      Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
        response = http.head(uri.path)
        return response['Content-Type']
      end
    rescue StandardError => e
      puts "Error fetching content type for #{url}: #{e.message}"
      nil
    end

    def get_extension_from_content_type(content_type)
      case content_type
      when 'image/jpeg' then '.jpg'
      when 'image/png'  then '.png'
      when 'image/gif'  then '.gif'
      else '.jpg'  # Default to jpg if unknown
      end
    end

    User.find_each do |user|
      puts "\nProcessing user: #{user.email} (ID: #{user.id})"

      # Update avatar URL
      if user.avatar.present?
        new_avatar_url = "https://linkarooie.syd1.digitaloceanspaces.com/avatars/#{user.id}_#{user.username}_avatar.jpg"
        if user.avatar != new_avatar_url
          puts "  Old avatar URL: #{user.avatar}"
          puts "  New avatar URL: #{new_avatar_url}"
          user.update_column(:avatar, new_avatar_url)
          puts "  Avatar URL updated successfully"
        else
          puts "  Avatar URL already correct: #{user.avatar}"
        end
      else
        puts "  No avatar URL present"
      end

      # Update banner URL
      if user.banner.present?
        if user.banner.start_with?('https://linkarooie.syd1.digitaloceanspaces.com/banners/') && !File.extname(user.banner).present?
          content_type = fetch_content_type(user.banner)
          if content_type
            extension = get_extension_from_content_type(content_type)
            new_banner_url = "https://linkarooie.syd1.digitaloceanspaces.com/banners/#{user.id}_#{user.username}_banner#{extension}"
            puts "  Old banner URL: #{user.banner}"
            puts "  New banner URL: #{new_banner_url}"
            user.update_column(:banner, new_banner_url)
            puts "  Banner URL updated successfully"
          else
            puts "  Couldn't determine file type for banner: #{user.banner}"
          end
        else
          new_banner_url = "https://linkarooie.syd1.digitaloceanspaces.com/banners/#{user.id}_#{user.username}_banner.jpg"
          if user.banner != new_banner_url
            puts "  Old banner URL: #{user.banner}"
            puts "  New banner URL: #{new_banner_url}"
            user.update_column(:banner, new_banner_url)
            puts "  Banner URL updated successfully"
          else
            puts "  Banner URL already correct: #{user.banner}"
          end
        end
      else
        puts "  No banner URL present"
      end
    end

    puts "\nUser image URL update completed!"
  end
end
