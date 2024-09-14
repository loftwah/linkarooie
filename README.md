# Linkarooie

[![Build Status](https://github.com/loftwah/linkarooie/actions/workflows/ci.yml/badge.svg)](https://github.com/loftwah/linkarooie/actions) [![Docker Image Available](https://img.shields.io/badge/Docker%20image-available-blue?logo=docker)](https://github.com/users/loftwah/packages/container/package/linkarooie) [![HealthCheck](https://healthcheck.eddiehubcommunity.org/api/badges/report/cm0cggpxg0006p2fp0x06g7hv)](https://healthcheck.eddiehubcommunity.org/api/report/latest/cm0cggpxg0006p2fp0x06g7hv)

![Judgemental Linkarooie](https://github.com/user-attachments/assets/65378fe8-d0ae-4682-9f15-64007b5b0818)

Linkarooie is a robust, open-source alternative to Linktree, built with Ruby on Rails. It provides a centralized platform for managing and sharing your important links, achievements, and online presence. Created as a replacement for the archived BioDrop (LinkFree) project, Linkarooie offers a feature-rich, customizable solution designed for easy deployment and management.

## Table of Contents

1. [Features](#features)
2. [Tech Stack](#tech-stack)
3. [Getting Started](#getting-started)
   - [Prerequisites](#prerequisites)
   - [Local Development Setup](#local-development-setup)
   - [Creating a New User](#creating-a-new-user)
4. [Docker Deployment](#docker-deployment)
5. [DigitalOcean Deployment](#digitalocean-deployment)
6. [Configuration](#configuration)
   - [Environment Variables](#environment-variables)
   - [Database Configuration](#database-configuration)
7. [Backup and Restore Process](#backup-and-restore-process)
8. [Geolocation](#geolocation)
9. [Customization](#customization)
10. [Testing](#testing)
11. [CI/CD](#cicd)
12. [Project Structure](#project-structure)
13. [Key Components](#key-components)
14. [Gather Script](#gather-script)
15. [Contributing](#contributing)
16. [License](#license)
17. [Support](#support)
18. [Acknowledgements](#acknowledgements)

## Video Demo

[Video Demo](https://github.com/user-attachments/assets/d5dc1636-2a7f-4cbf-878c-516ebda6c47e)

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
  - Geolocation tracking for visitor insights (currently mandatory)

- **Open Graph Image Generation:** 
  - Automatic creation of social media preview images for improved sharing

- **Responsive Design:** 
  - Ensures optimal user experience across all devices

- **Background Job Processing:** 
  - Utilizes Sidekiq for efficient handling of background tasks

- **Asset Management:** 
  - Implements Vite for modern, efficient frontend asset handling

- **Automated Backups:** 
  - Daily backups to DigitalOcean Spaces with easy restoration process

## Tech Stack

- **Backend:**
  - Ruby 3.3.0 (local development)
  - Ruby 3.3.4 (production Docker image)
  - Rails 7.1.3
  - SQLite3 (development)
  - PostgreSQL/MySQL (recommended for production)
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
- Rails 7.1.3 or higher
- SQLite3
- Node.js (v20 or higher) and npm
- Docker and Docker Compose (for containerized deployment)
- Git

### Local Development Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/loftwah/linkarooie.git
   cd linkarooie
   ```

2. Install Ruby dependencies:
   ```bash
   bundle install
   ```

3. Install JavaScript dependencies:
   ```bash
   npm install
   ```

4. Set up the database:
   ```bash
   rails db:create db:migrate db:seed
   ```

5. Start the development servers:
   ```bash
   bin/dev
   ```
   This command starts the Rails server, Vite dev server, and Tailwind CSS watcher.

6. Visit `http://localhost:3000` in your browser to access the application.

### Creating a New User

Linkarooie provides an interactive Ruby script for creating new users:

1. Run the script:
   ```bash
   ruby create_user.rb
   ```

2. Follow the prompts to enter user details, including:
   - Email
   - Password
   - Username (optional)
   - Full name
   - Tags (comma-separated)
   - Avatar URL
   - Banner URL
   - Description

This script allows for easy user creation, especially useful for setting up initial accounts or testing.

## Docker Deployment

Linkarooie uses Docker for easy deployment and scaling. The project includes a multi-stage Dockerfile for creating a lean production image.

1. Build and start the Docker containers:
   ```bash
   docker compose -f docker-compose.prod.yml up --build
   ```

2. Access the application at `http://localhost`.

The production Docker setup includes:
- Rails application container
- Redis container for Sidekiq and caching
- Sidekiq container for background job processing

Key Dockerfile features:
- Multi-stage build for a smaller final image
- Precompilation of assets and bootsnap
- Non-root user for improved security

## DigitalOcean Deployment

Linkarooie is optimized for deployment on DigitalOcean using Terraform for infrastructure management and GitHub Actions for continuous deployment.

### Setting up DigitalOcean Infrastructure

1. Install Terraform and set up a DigitalOcean account.

2. Configure your DigitalOcean API token:
   ```bash
   export DO_TOKEN=your_digitalocean_api_token
   ```

3. Create a DigitalOcean Droplet:
   ```bash
   cd terraform/droplet
   terraform init
   terraform apply -var="do_token=$DO_TOKEN"
   ```

4. Set up DigitalOcean Spaces for backups:
   ```bash
   cd ../spaces
   terraform init
   terraform apply
   ```

### Configuring GitHub Actions

1. Set up the following secrets in your GitHub repository:
   - `DROPLET_IP`: The IP address of your DigitalOcean Droplet (output from Terraform)
   - `DROPLET_SSH_PRIVATE_KEY`: The private SSH key to access your Droplet
   - `GH_PAT`: Your GitHub Personal Access Token

2. The GitHub Actions workflows will automatically:
   - Run tests and build Docker images on pull requests and pushes to feature branches
   - Deploy to your DigitalOcean Droplet when changes are merged to the main branch

### Manual Deployment

You can also trigger a manual deployment using the GitHub Actions workflow dispatch event.

## Configuration

### Environment Variables

Create a `.env` file in the root directory with the following variables:

```
SECRET_KEY_BASE=your_secret_key_base
AXIOM_API_KEY=your_axiom_api_key
DO_TOKEN=your_digitalocean_token
SPACES_ACCESS_KEY_ID=your_spaces_access_key_id
SPACES_SECRET_ACCESS_KEY=your_spaces_secret_access_key
SPACES_REGION=your_spaces_region
SPACES_BUCKET_NAME=your_spaces_bucket_name
RAILS_ENV=production
CACHE_EXPIRATION=30
```

Ensure all placeholder values are replaced with your actual API keys and tokens.

### Database Configuration

- Development and test environments use SQLite3.
- For production, configure your preferred database (PostgreSQL recommended) in `config/database.yml`.

## Backup and Restore Process

Linkarooie includes an automated backup system utilizing DigitalOcean Spaces:

### Automated Backups

- The `BackupDatabaseJob` runs daily at 2 AM.
- It creates a dump of the SQLite database and uploads it to a DigitalOcean Spaces bucket.
- Backups are versioned for easy point-in-time recovery.

### Restoring from a Backup

Use the provided Rake task to restore from a backup:

```bash
rake db:restore BACKUP_FILE=path/to/your_backup_file.sql
```

For compressed backups:

```bash
rake db:restore BACKUP_FILE=path/to/your_backup_file.sql.tar.gz
```

The restore process:
1. Drops all existing tables in the database.
2. Loads the specified backup file.
3. Applies any pending migrations.

## Geolocation

Geolocation is currently a mandatory feature in Linkarooie. It uses the `geocoder` gem to provide location-based insights for link clicks and page views.

To enable geolocation:
1. Obtain a free API key from [ipapi](https://ipapi.com).
2. Set the `GEOCODER_API_KEY` environment variable with your API key.

Future plans include making geolocation optional to cater to different privacy preferences.

## Customization

Linkarooie is designed to be highly customizable:

- **Views:** Modify ERB templates in `app/views/`
- **Styles:** 
  - Edit Tailwind CSS classes directly in views
  - Customize Tailwind configuration in `config/tailwind.config.js`
  - Add custom styles in `app/assets/stylesheets/application.css.scss`
- **JavaScript:** 
  - Add or modify Stimulus controllers in `app/javascript/controllers/`
  - Update the main JavaScript file at `app/javascript/application.js`
- **Backend Logic:** 
  - Controllers are located in `app/controllers/`
  - Models are in `app/models/`
- **Background Jobs:** Add or modify Sidekiq jobs in `app/jobs/`
- **Localization:** Update language files in `config/locales/`

## Testing

Linkarooie uses RSpec for testing. The test suite includes:
- Model specs
- Controller specs
- Feature specs
- Helper specs

To run the entire test suite:

```bash
bundle exec rspec
```

To run specific tests:

```bash
bundle exec rspec spec/models
bundle exec rspec spec/controllers
bundle exec rspec spec/features
```

## CI/CD

Linkarooie utilizes GitHub Actions for continuous integration and deployment:

1. **CI Workflow** (`ci.yml`):
   - Triggered on pull requests to `main` and pushes to feature branches
   - Sets up Ruby and Node.js environments
   - Installs dependencies
   - Runs tests
   - Builds and pushes Docker image to GitHub Container Registry

2. **Deployment Workflow** (`deploy.yml`):
   - Triggered on merges to `main` or manual dispatch
   - Builds and pushes Docker image
   - SSHs into the DigitalOcean Droplet
   - Pulls the latest Docker image
   - Runs database migrations
   - Restarts the application containers

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

- **User Model:** Manages user accounts, profiles, and authentication.
- **Link Model:** Handles the creation and management of user links.
- **Achievement Model:** Manages user achievements and milestones.
- **Analytics:** Tracks and stores user engagement metrics.
- **OpenGraphImageGenerator:** Service for creating social media preview images.
- **BackupDatabaseJob:** Manages automated database backups.

## Gather Script

- [GRABIT.SH](https://grabit.sh) was inspired by this script.

The `gather.sh` script is a utility for collecting project information:

```bash
./gather.sh [-o output_method] [-f output_file]
  -o, --output         Output method: stdout, clipboard, or file (default: stdout)
  -f, --file           Output file path (required if output method is file)
```

> Note: There is also a `gather.rb` that works the same.

This script is useful for quickly compiling project details for documentation or sharing.

## Contributing

We welcome contributions to Linkarooie! Here's how you can help:

1. Fork the repository
2. Create your feature branch: `git checkout -b feature/AmazingFeature`
3. Commit your changes: `git commit -m 'Add some AmazingFeature'`
4. Push to the branch: `git push origin feature/AmazingFeature`
5. Open a Pull Request

Please ensure your code adheres to the existing style and passes all tests.

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
- [Devise](https://github.com/heartcombo/devise)
- [Chartkick](https://chartkick.com/)
- [Geocoder](https://github.com/alexreisner/geocoder)

---

Linkarooie © 2024 - Simplify Your Online Presence
