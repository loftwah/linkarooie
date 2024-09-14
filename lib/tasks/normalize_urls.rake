namespace :normalize do
  desc "Normalize URLs for all existing users' links and achievements"
  task normalize_urls: :environment do
    Link.find_each do |link|
      unless link.url.blank? || link.url =~ /\Ahttps?:\/\//
        link.update(url: "http://#{link.url}")
        puts "Normalized URL for link ID #{link.id}: #{link.url}"
      end
    end

    Achievement.find_each do |achievement|
      unless achievement.url.blank? || achievement.url =~ /\Ahttps?:\/\//
        achievement.update(url: "http://#{achievement.url}")
        puts "Normalized URL for achievement ID #{achievement.id}: #{achievement.url}"
      end
    end

    puts "URL normalization completed for all existing links and achievements."
  end
end
