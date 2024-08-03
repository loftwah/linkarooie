# db/seeds.rb

# Delete existing users, links, and achievements to avoid duplication
User.delete_all
Link.delete_all
Achievement.delete_all

# Create a new user with the fetched attributes
user = User.create!(
  email: "dean@deanlofts.xyz",
  encrypted_password: "$2a$12$svOkqgPLTEgvJT9ZTGXYHO20UUIQs9PF/im6bQaBBybmcrTKyDD6i",
  avatar: "https://pbs.twimg.com/profile_images/1756873036220059648/zc13kjbX_400x400.jpg",
  banner: "https://pbs.twimg.com/profile_banners/1192091185/1719830949/1500x500",
  description: "Revolutionize Your Social Media Strategy with Echosight. https://app.echosight.io | https://loftwah-demo.github.io/linux-for-pirates-2",
  username: "loftwah",
  full_name: "Dean Lofts",
  tags: ["AWS", "DevOps", "Docker", "GitHub", "Linux", "Open Source", "Ruby", "Ruby on Rails", "Terraform"].to_json,
  created_at: "2024-07-25 02:08:37",
  updated_at: "2024-07-26 15:29:25"
) do |user|
  user.save!(validate: false)
end

# Create associated links for the user
links_data = [
  {
    title: "GitHub",
    url: "https://github.com/loftwah",
    description: "My GitHub profile",
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
    description: "My Twitter/X profile.",
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
    description: "My Echosight public profile.",
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
    description: "My LinkedIn profile.",
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
    description: "My Threads profile.",
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
    description: "Lots of beats I have made over the years.",
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
    description: "A bunch of music that I produced.",
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

# Create associated achievements for the user
achievements_data = [
  {
    title: "Crossed 1K followers on GitHub",
    date: "2023-07-12",
    description: "I have reached 1000 followers on GitHub.",
    icon: "fa-brands fa-github",
    url: "https://github.com/loftwah",
    created_at: "2024-07-25 13:52:19",
    updated_at: "2024-07-25 13:52:19"
  },
  {
    title: "AWS Certified Solutions Architect – Professional",
    date: "2023-07-12",
    description: "Earners of this certification have an extensive understanding of designing technical strategies to accomplish specific business goals. They demonstrated the ability to balance best practices and trade-offs based on business context. Badge owners are able to design solutions across multiple platforms and providers.",
    icon: "fa-brands fa-aws",
    url: "https://www.credly.com/badges/c97a35fc-ba6b-427a-b521-19b9ab28cfdb/facebook",
    created_at: "2024-07-25 14:00:01",
    updated_at: "2024-07-25 14:00:01"
  },
  {
    title: "Became an EddieHub 0.2 Ambassador",
    date: "2023-01-18",
    description: "I accepted the role as part of the EddieHub Ambassador 0.2 cohort.",
    icon: "fa-brands fa-github",
    url: "https://eddiehub.org/",
    created_at: "2024-07-25 14:04:56",
    updated_at: "2024-07-25 14:04:56"
  },
  {
    title: "HashiCorp Certified: Terraform Associate (003)",
    date: "2024-04-18",
    description: "Earners of the HashiCorp Certified: Terraform Associate certification know the basic concepts, skills, and use cases associated with open source HashiCorp Terraform. They understand and can utilize Terraform according to the certification objectives. Additionally, they understand why enterprises choose to extend Terraform Open Source with Terraform Enterprise to solve business critical objectives.",
    icon: "fa-solid fa-cloud",
    url: "https://www.credly.com/badges/0e437888-1deb-4a2d-8b82-cefb6b87b35d/public_url",
    created_at: "2024-07-26 05:13:44",
    updated_at: "2024-07-26 05:14:00"
  }
]

achievements_data.each do |achievement|
  user.achievements.create!(achievement)
end
