# Loftwah's Custom Dashboard

## Overview

This custom dashboard is a Ruby on Rails application developed for personal use and serves as a learning platform for Ruby on Rails. The dashboard is designed to be the default page that opens up in your web browser. It features the capability to manage links and customize the look and feel to match your preferences.

### Built With

* Ruby 3.2.2
* Ruby on Rails
* SQLite Database (PostgreSQL in production coming soon)
* AWS Services (coming soon)
* GitHub Actions (coming soon)
* Ubuntu 22.04

## Features

* **Add Links**: Easily add links to your dashboard that open in a new window.
* **Pin Links**: Highlight essential links for easy access.
* **Customization**: Change the background color and add a background image to personalize your dashboard.
* **User Management**: Sign up and manage your customized dashboard settings.

## Getting Started

### Prerequisites

* Ruby 3.2.2
* Ruby on Rails
* SQLite
* NodeJS
* Yarn

### Installation

1. Clone the repository.

`   git clone https://github.com/loftwah/custom-dashboard.git`

2. Navigate to the project directory.

`   cd custom-dashboard`

3. Install dependencies.

    ```bash
    bundle install
    yarn install
    ```

4. Create and migrate the database.

    ```bash
    rails db:create db:migrate
    ```

5. Start the Rails server.

    ```bash
    rails s
    ```

Visit `http://localhost:3000` to view your custom dashboard.

## Usage

To add links, sign up and navigate to your dashboard settings. Here, you can manage and pin links, as well as customize your dashboard's appearance.

## AWS Services Used (coming soon)

* S3
* EC2
* ECS
* RDS
* Elasticache
* SNS
* SQS
* SES
* Twilio
* Cloudflare

## GitHub Actions Workflow (coming soon)

All code changes are automatically tested using GitHub Actions, focusing on region-specific AWS integration tests.

## Contributing

This project is for personal use and learning. Feel free to fork and use it as a base for your custom dashboard.

## License

MIT License. See `LICENSE` for more information.