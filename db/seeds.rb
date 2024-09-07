# db/seeds.rb

# Only delete existing records in development or test environments to avoid destroying live data.
if Rails.env.development? || Rails.env.test?
  # Delete existing records in the correct order to avoid foreign key constraints
  PageView.delete_all
  LinkClick.delete_all
  AchievementView.delete_all
  DailyMetric.delete_all
  Link.delete_all
  Achievement.delete_all
  User.delete_all
else
  Rails.logger.info "Skipping deletion of records in production environment."
end

# Warning! Default user setup for those too lazy to create their own. Change the password, seriously.
user = User.new(
  email: "dean@deanlofts.xyz", # Because why not use the most generic email ever?
  password: "Password0!", # Yeah, this is the default. We trust you'll change it. Hopefully.
  avatar: "https://pbs.twimg.com/profile_images/1581014308397502464/NPogKMyk_400x400.jpg", # Handsome devil, aren't I?
  banner: "https://pbs.twimg.com/profile_banners/1192091185/1719830949/1500x500", # So majestic, much wow.
  description: "Revolutionize Your Social Media Strategy with Echosight... Or not, your call. https://app.echosight.io | https://loftwah-demo.github.io/linux-for-pirates-2",
  username: "loftwah", # Of course it's 'loftwah', what else would it be?
  full_name: "Dean Lofts", # Sounds professional, but let's not kid ourselves.
  tags: ["AWS", "DevOps", "Docker", "GitHub", "Linux", "Open Source", "Ruby", "Ruby on Rails", "Terraform"].to_json, # So many buzzwords, so little time.
  banner_enabled: true, # Banner is now on
  public_analytics: true, # Public analytics is now on
  community_opt_in: true, # Community opt-in is on
  created_at: "2024-07-25 02:08:37", # Yeah, I coded at 2 AM, judge me.
  updated_at: "2024-07-26 15:29:25" # Updated after fixing a 'totally intentional' bug.
)
user.save!(validate: false) # Who needs validation anyway? We're pros here.

# Now for some links, because you need to know EVERYTHING about me, obviously.
links_data = [
  {
    title: "GitHub",
    url: "https://github.com/loftwah",
    description: "Where I pretend to be productive.",
    position: 2,
    icon: "fa-brands fa-github",
    visible: true,
    pinned: true,
    created_at: "2024-07-25 09:56:42",
    updated_at: "2024-07-26 14:17:49"
  },
  {
    title: "Twitter/X",
    url: "https://x.com/loftwah",
    description: "Just another platform to procrastinate on.",
    position: 3,
    icon: "fa-brands fa-x-twitter",
    visible: true,
    pinned: true,
    created_at: "2024-07-25 09:57:57",
    updated_at: "2024-07-26 14:17:54"
  },
  {
    title: "My Echosight",
    url: "https://app.echosight.io/p/loftwah",
    description: "Shameless self-promotion. No shame, no game.",
    position: 0,
    icon: "fa-solid fa-star",
    visible: true,
    pinned: false,
    created_at: "2024-07-26 05:11:11",
    updated_at: "2024-07-26 14:39:50"
  },
  {
    title: "LinkedIn",
    url: "https://linkedin.com/in/deanlofts",
    description: "Where I pretend to be a 'serious professional.'",
    position: 7,
    icon: "fa-brands fa-linkedin",
    visible: true,
    pinned: true,
    created_at: "2024-07-26 14:40:31",
    updated_at: "2024-07-26 14:40:31"
  },
  {
    title: "Threads",
    url: "https://www.threads.net/@loftwah",
    description: "Because one social platform isn’t enough, clearly.",
    position: 8,
    icon: "fa-brands fa-threads",
    visible: true,
    pinned: true,
    created_at: "2024-07-26 14:41:53",
    updated_at: "2024-07-26 14:41:53"
  },
  {
    title: "Loftwah The Beatsmiff Beats",
    url: "https://www.youtube.com/playlist?list=PLKBAUoCO_FtlACntcZqTOD4hckJ8IAWZ3",
    description: "All the beats you never knew you needed.",
    position: 9,
    icon: "fa-solid fa-music",
    visible: true,
    pinned: false,
    created_at: "2024-07-26 14:44:14",
    updated_at: "2024-07-26 14:44:14"
  },
  {
    title: "Produced by Loftwah The Beatsmiff",
    url: "https://www.youtube.com/playlist?list=PLKBAUoCO_FtkHiwRzyGzfhauIhNMBFw66",
    description: "Music made with love, or at least caffeine.",
    position: 10,
    icon: "fa-solid fa-music",
    visible: true,
    pinned: false,
    created_at: "2024-07-26 14:48:59",
    updated_at: "2024-07-26 14:50:02"
  }
]

links_data.each do |link|
  user.links.create!(link)
end

# Achievements! Because I’m apparently awesome.
achievements_data = [
  {
    title: "Crossed 1K followers on GitHub",
    date: "2023-07-12",
    description: "Proof that at least 1,000 people like my code. Or bots. Probably bots.",
    icon: "fa-brands fa-github",
    url: "https://github.com/loftwah",
    created_at: "2024-07-25 13:52:19",
    updated_at: "2024-07-25 13:52:19"
  },
  {
    title: "AWS Certified Solutions Architect – Professional",
    date: "2023-07-12",
    description: "Because why not flex on AWS, right?",
    icon: "fa-brands fa-aws",
    url: "https://www.credly.com/badges/c97a35fc-ba6b-427a-b521-19b9ab28cfdb/facebook",
    created_at: "2024-07-25 14:00:01",
    updated_at: "2024-07-25 14:00:01"
  },
  {
    title: "Became an EddieHub 0.2 Ambassador",
    date: "2023-01-18",
    description: "Finally made it into the EddieHub elite. Version 0.2, though, not 1.0 yet.",
    icon: "fa-brands fa-github",
    url: "https://eddiehub.org/",
    created_at: "2024-07-25 14:04:56",
    updated_at: "2024-07-25 14:04:56"
  },
  {
    title: "HashiCorp Certified: Terraform Associate (003)",
    date: "2024-04-18",
    description: "Terraform: Because clouds aren't going to manage themselves.",
    icon: "fa-solid fa-cloud",
    url: "https://www.credly.com/badges/0e437888-1deb-4a2d-8b82-cefb6b87b35d/public_url",
    created_at: "2024-07-26 05:13:44",
    updated_at: "2024-07-26 05:14:00"
  }
]

achievements_data.each do |achievement|
  user.achievements.create!(achievement)
end

# Note: Don’t forget to change the default password, or you'll have a bad time. Or just leave it as is... I won't judge.
