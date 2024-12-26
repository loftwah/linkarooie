# Linkarooie

[![Build Status](https://github.com/loftwah/linkarooie/actions/workflows/ci.yml/badge.svg)](https://github.com/loftwah/linkarooie/actions) [![Docker Image Available](https://img.shields.io/badge/Docker%20image-available-blue?logo=docker)](https://github.com/users/loftwah/packages/container/package/linkarooie)

![Judgemental Linkarooie](https://github.com/user-attachments/assets/65378fe8-d0ae-4682-9f15-64007b5b0818)

Linkarooie is a robust, open-source alternative to Linktree, built with Ruby on Rails. It provides a centralized platform for managing and sharing your important links, achievements, and online presence. Created as a replacement for the archived BioDrop (LinkFree) project, Linkarooie offers a feature-rich, customizable solution designed for easy deployment and management.

## Table of Contents

1. [Features](#features)
2. [Tech Stack](#tech-stack)
3. [Getting Started](#getting-started)
4. [Deployment](#deployment)
5. [Configuration](#configuration)
6. [Backup and Restore Process](#backup-and-restore-process)
7. [Customization](#customization)
8. [Testing](#testing)
9. [CI/CD Pipeline](#cicd-pipeline)
10. [Project Structure](#project-structure)
11. [Key Components](#key-components)
12. [Rails Console Commands](#rails-console-commands)
13. [Contributing](#contributing)
14. [License](#license)
15. [Support](#support)
16. [Acknowledgements](#acknowledgements)

## Features

- **Custom Links Management:**

  - Add, edit, and delete links with titles, URLs, descriptions, and custom icons
  - Toggle link visibility
  - Pin important links to the top of your profile
  - Organize links with custom positioning

- **User Profiles:**

  - Customizable profiles with avatars, banners, full names, usernames, and descriptions
  - Tagging system for categorizing profiles

- **User Achievements:**

  - Create and showcase personal or professional accomplishments
  - Include achievement titles, dates, descriptions, icons, and URLs

- **Analytics:**

  - Track page views, link clicks, and unique visitors
  - View daily metrics for user engagement
  - Geolocation tracking for visitor insights

- **Open Graph Image Generation:**

  - Automatic creation of social media preview images for improved sharing

- **Responsive Design:**

  - Ensures optimal user experience across all devices

- **Background Job Processing:**

  - Utilizes Sidekiq for efficient handling of background tasks

- **Asset Management:**

  - Implements Vite for modern, efficient frontend asset handling

- **Automated Backups:**
  - Daily backups to DigitalOcean Spaces with automatic 30-day cleanup
  - Easy restoration process

## Tech Stack

- **Backend:**

  - Ruby 3.3.0 (local development)
  - Ruby 3.3.4 (production Docker image)
  - Rails 8.0.1
  - SQLite3 (development)
  - Sidekiq for background job processing
  - Redis for Sidekiq and caching

- **Frontend:**

  - Vite for asset compilation and management
  - Tailwind CSS for styling
  - Stimulus.js for JavaScript sprinkles
  - Chartkick for chart generation

- **Testing:**

  - RSpec for unit and integration tests
  - Factory Bot for test data generation
  - Shoulda Matchers for additional RSpec matchers

- **Deployment & Infrastructure:**

  - Docker and Docker Compose for containerization
  - Kamal for zero-downtime deployments
  - GitHub Actions for CI/CD
  - Terraform for infrastructure as code
  - DigitalOcean for hosting (Droplets and Spaces)

- **Additional Libraries:**
  - Devise for authentication
  - Geocoder for geolocation services
  - AWS SDK for S3 compatible storage interactions
  - Font Awesome for icons

## Getting Started

### Prerequisites

- Ruby 3.3.0 or higher
- Rails 8.0.1 or higher
- SQLite3
- Node.js (v20 or higher) and npm
- Docker and Docker Compose
- Git

### Local Development Setup

1. Clone the repository:

   ```bash
   git clone https://github.com/loftwah/linkarooie.git
   cd linkarooie
   ```

2. Install dependencies:

   ```bash
   bundle install
   npm install
   ```

3. Set up the database:

   ```bash
   rails db:create db:migrate db:seed
   ```

4. Start the development servers:

   ```bash
   bin/dev
   ```

5. Visit `http://localhost:3000` in your browser

## Deployment

Linkarooie uses [Kamal](https://kamal-deploy.org/) for zero-downtime deployments to DigitalOcean:

### Environment Setup

1. Configure your environment variables in GitHub Secrets:

   ```bash
   KAMAL_REGISTRY_PASSWORD=your_registry_password
   KAMAL_REGISTRY_USERNAME=your_registry_username
   SECRET_KEY_BASE=your_secret_key_base
   AXIOM_API_KEY=your_axiom_api_key
   DO_TOKEN=your_digitalocean_token
   SPACES_REGION=your_spaces_region
   SPACES_BUCKET_NAME=your_spaces_bucket_name
   SPACES_BUCKET_CONTENT=your_spaces_bucket_content
   SPACES_ACCESS_KEY_ID=your_spaces_access_key_id
   SPACES_SECRET_ACCESS_KEY=your_spaces_secret_access_key
   RAILS_MASTER_KEY=your_rails_master_key
   DROPLET_SSH_PRIVATE_KEY=your_ssh_private_key
   ```

2. Set up your deployment configuration in `config/deploy.yml` and `config/deploy.production.yml`

### Deployment Methods

#### 1. Automated Deployment

Changes pushed to the `main` branch trigger automatic deployment through GitHub Actions:

```bash
# .github/workflows/01.deploy_to_production.yml
# Deploys automatically when:
# 1. Direct push to main
# 2. CI workflow completed successfully on main branch
```

#### 2. Manual Deployment

Use the GitHub Actions interface to trigger manual deployments:

```bash
# .github/workflows/02.deploy_manually.yml
# Allows manual deployment to production through GitHub UI
```

#### 3. Server Management

Run Kamal commands through GitHub Actions:

```bash
# .github/workflows/03.kamal_run_command.yml
# Supports commands like:
# - proxy reboot --rolling -y
# - upgrade --rolling -y
```

### Infrastructure Management

Terraform is used to manage DigitalOcean infrastructure:

```bash
# Create DigitalOcean Droplet
cd terraform/droplet
terraform init
terraform apply -var="do_token=$DO_TOKEN"

# Set up DigitalOcean Spaces
cd ../spaces
terraform init
terraform apply -var="do_token=$DO_TOKEN" \
                -var="spaces_access_id=$SPACES_ACCESS_KEY_ID" \
                -var="spaces_secret_key=$SPACES_SECRET_ACCESS_KEY"
```

## Configuration

### Environment Variables

Create a `.env` file in the root directory with the following variables:

```bash
SECRET_KEY_BASE=your_secret_key_base
AXIOM_API_KEY=your_axiom_api_key
DO_TOKEN=your_digitalocean_token
SPACES_ACCESS_KEY_ID=your_spaces_access_key_id
SPACES_SECRET_ACCESS_KEY=your_spaces_secret_access_key
SPACES_REGION=your_spaces_region
SPACES_BUCKET_NAME=your_spaces_bucket_name
SPACES_BUCKET_CONTENT=your_spaces_bucket_content
RAILS_ENV=production
CACHE_EXPIRATION=30
```

### Database Configuration

Development and test environments use SQLite3. The database configuration is in `config/database.yml`.

## Backup and Restore Process

Linkarooie includes an automated backup system utilizing DigitalOcean Spaces:

### Automated Backups

- The `BackupDatabaseJob` runs daily at 2 AM
- Creates a dump of the SQLite database and uploads it to DigitalOcean Spaces
- `CleanupOldBackupsJob` runs daily at 3 AM to remove backups older than 30 days
- Email notifications for backup creation and cleanup

### Restoring from a Backup

Use the provided Rake task:

```bash
# For uncompressed backups
rake db:restore BACKUP_FILE=path/to/your_backup_file.sql

# For compressed backups
rake db:restore BACKUP_FILE=path/to/your_backup_file.sql.tar.gz
```

## Customization

- **Views:** Modify ERB templates in `app/views/`
- **Styles:**
  - Edit Tailwind CSS classes directly in views
  - Customize Tailwind configuration in `config/tailwind.config.js`
- **JavaScript:**
  - Add or modify Stimulus controllers in `app/javascript/controllers/`
  - Update the main JavaScript file at `app/javascript/application.js`
- **Backend Logic:**
  - Controllers are in `app/controllers/`
  - Models are in `app/models/`
- **Background Jobs:** Add or modify Sidekiq jobs in `app/jobs/`

## Testing

Run the test suite:

```bash
# Run all tests
bundle exec rspec

# Run specific test directories
bundle exec rspec spec/models
bundle exec rspec spec/controllers
bundle exec rspec spec/features
```

## CI/CD Pipeline

### 1. Continuous Integration (`ci.yml`)

- Triggered on:
  - Pull requests to `main`
  - Pushes to feature branches
- Actions:
  - Sets up Ruby and Node.js
  - Installs dependencies
  - Builds Vite assets
  - Compiles Tailwind CSS
  - Sets up database
  - Runs RSpec tests
  - Builds Docker image

### 2. Production Deployment (`01.deploy_to_production.yml`)

- Triggered on:
  - Merges to `main`
  - Successful CI workflow completion
- Uses Kamal for:
  - Zero-downtime deployments
  - Docker image management
  - Application server configuration
  - Environment variable management

### 3. Manual Deployment (`02.deploy_manually.yml`)

- Allows manual deployment through GitHub Actions interface
- Supports multiple environments (currently production only)
- Uses the same Kamal deployment process as automated deployments

### 4. Server Management (`03.kamal_run_command.yml`)

- Provides interface for running Kamal commands
- Supports operations like:
  - Rolling proxy reboots
  - Rolling upgrades
  - Custom Kamal commands

### Supporting Actions

- `kamal-deploy/action.yml`: Reusable Kamal deployment workflow
- `setup/action.yml`: Common setup steps for all workflows

## Project Structure

```
linkarooie/
├── app/
│   ├── assets/
│   ├── controllers/
│   ├── helpers/
│   ├── javascript/
│   ├── jobs/
│   ├── mailers/
│   ├── models/
│   ├── services/
│   └── views/
├── bin/
├── config/
├── db/
├── lib/
├── public/
├── spec/
├── storage/
├── terraform/
│   ├── droplet/
│   └── spaces/
├── .github/workflows/
├── Dockerfile
├── docker-compose.prod.yml
├── Gemfile
├── package.json
└── ...
```

## Key Components

- **User Model:** Manages user accounts, profiles, and authentication
- **Link Model:** Handles the creation and management of user links
- **Achievement Model:** Manages user achievements and milestones
- **Analytics:** Tracks and stores user engagement metrics
- **OpenGraphImageGenerator:** Creates social media preview images
- **BackupDatabaseJob:** Manages automated database backups

## Rails Console Commands

### User Management

```ruby
# Create a user
User.create!(
  email: "user@example.com",
  password: "Password123",
  username: "newuser",
  full_name: "New User",
  tags: ["Tech", "Music"].to_json,
  avatar: "https://example.com/avatar.png",
  avatar_border: "white",
  banner: "https://example.com/banner.png",
  description: "User description",
  community_opt_in: true,
  public_analytics: true
)

# List users
User.pluck(:email, :username, :full_name)

# Update a user
user = User.find_by(email: "user@example.com")
user.update!(full_name: "Updated Name")

# Delete a user
user = User.find_by(email: "user@example.com")
user.destroy!
```

### Analytics

```ruby
# View total page views for a user
user = User.find_by(username: "username")
user.page_views.count

# Get unique visitors
user.page_views.distinct.count(:ip_address)

# View detailed page views
user.page_views.pluck(:path, :visited_at, :referrer, :browser)
```

## Contributing

1. Fork the repository
2. Create your feature branch: `git checkout -b feature/AmazingFeature`
3. Commit your changes: `git commit -m 'Add some AmazingFeature'`
4. Push to the branch: `git push origin feature/AmazingFeature`
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

If you find Linkarooie helpful, please consider:

- Starring the repository on GitHub
- Sharing the project with others
- Contributing to the codebase
- Reporting issues or suggesting improvements

## Acknowledgements

- [Ruby on Rails](https://rubyonrails.org/)
- [Tailwind CSS](https://tailwindcss.com/)
- [Docker](https://www.docker.com/)
- [DigitalOcean](https://www.digitalocean.com/)
- [Terraform](https://www.terraform.io/)
- [Vite](https://vitejs.dev/)
- [Sidekiq](https://sidekiq.org/)
- [Kamal](https://kamal-deploy.org/)
- [Devise](https://github.com/heartcombo/devise)
- [Chartkick](https://chartkick.com/)

---

Linkarooie © 2024 - Simplify Your Online Presence
