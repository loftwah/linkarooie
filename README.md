# Linkarooie

[![Build Status](https://github.com/loftwah/linkarooie/actions/workflows/ci.yml/badge.svg)](https://github.com/loftwah/linkarooie/actions)

Linkarooie is a simple and open-source alternative to Linktree, allowing you to manage and share all your important links in one place. This project was created as a replacement for BioDrop (LinkFree) after it was archived. It is built using Ruby on Rails and is designed to be easy to deploy and customize.

## Features

- **Custom Links:** Easily add and manage your links.
- **Analytics:** Track the performance of your links.
- **Social Integration:** Seamlessly connect all your social media profiles.
- **Responsive Design:** Works well on any device.
- **User Achievements:** Showcase your accomplishments.
- **Pinned Links:** Highlight your most important links.
- **User Profiles:** Customizable profiles with avatars, banners, and descriptions.
- **Open Graph Image Generation:** Automatically generate social media preview images.

## Demo

Check out a live demo at [linkarooie.com](https://linkarooie.com).

## Getting Started

### Prerequisites

- Ruby 3.3.0 or higher
- Rails 7.1.3 or higher
- SQLite3
- Node.js and npm (for asset compilation)
- Docker and Docker Compose (for containerized deployment)
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
   rails db:create db:migrate
   ```

4. Start the Rails server:

   ```bash
   bin/dev
   ```

5. Visit `http://localhost:3000` in your browser.

### Creating a New User

This section explains how to create a new user using an interactive Ruby script. This method allows you to quickly add users to your Rails application with the required and optional attributes.

#### Using the Interactive Ruby Script

The Ruby script offers a user-friendly and interactive way to create a new user by prompting you for the required and optional details.

##### Usage

Run the script by navigating to your Rails project directory and executing the following command:

```bash
ruby create_user.rb
```

You will be prompted to enter various details for the new user:

```bash
Enter email: bob.johnson@example.com
Enter password: AnotherSuperSecretPassword
Enter username (or leave blank to use email prefix): bob_j
Enter full name: Bob Johnson
Enter tags (comma-separated): Marketing,SEO,Content Strategy
Enter avatar URL: https://pbs.twimg.com/profile_images/1756873036220059648/zc13kjbX_400x400.jpg
Enter banner URL: https://pbs.twimg.com/profile_banners/1192091185/1719830949/1500x500
Enter description: Digital marketing expert focused on driving growth through innovative SEO and content strategies.
```

##### Example

The details entered above will create a user with the following attributes:

* **Email:** `bob.johnson@example.com`
* **Password:** `AnotherSuperSecretPassword`
* **Username:** `bob_j`
* **Full Name:** `Bob Johnson`
* **Tags:** `Marketing`, `SEO`, `Content Strategy`
* **Avatar:** Same as provided
* **Banner:** Same as provided
* **Description:** "Digital marketing expert focused on driving growth through innovative SEO and content strategies."

After entering all the details, the script will create the user and confirm whether the process was successful.

### Docker Deployment

1. Build and start the Docker containers:

   ```bash
   docker compose up --build
   ```

2. Visit `http://localhost` in your browser.

Note: The Dockerfile uses a multi-stage build process to create a lean production image. It installs necessary dependencies, precompiles assets, and sets up the application to run as a non-root user for improved security.

### DigitalOcean Deployment

1. Set up a DigitalOcean account and generate an API token.

2. Create a DigitalOcean Droplet with Terraform:

   ```bash
   terraform init
   terraform apply -var="do_token=YOUR_DIGITALOCEAN_TOKEN"
   ```

3. Deploy the app using GitHub Actions:

   * Ensure you have the following secrets set in your GitHub repository:
     * `DROPLET_IP`: The IP address of your DigitalOcean Droplet (output from Terraform).
     * `DROPLET_SSH_PRIVATE_KEY`: The private SSH key to access your Droplet.
     * `GH_PAT`: Your GitHub Personal Access Token.

   * Push your code to the `main` branch, and the GitHub Actions workflow will automatically deploy the latest version to your Droplet.

4. Important Note on Docker Installation:
   The user data script in the Terraform configuration installs Docker using the get.docker.com script. However, this installation is not instantaneous and may take a few minutes to complete after the Droplet is created.

5. Checking Docker Installation Status:
   If you encounter issues with Docker not being available immediately after Droplet creation, you can check the cloud-init logs:

   ```bash
   ssh root@YOUR_DROPLET_IP
   sudo tail -f /var/log/cloud-init-output.log
   ```

   This will show you the progress of the initialization script, including the Docker installation.

## Configuration

### Environment Variables

- `RAILS_ENV`: Set to `production` for production environments.
- `SECRET_KEY_BASE`: Rails secret key for production.
- `DATABASE_URL`: Database connection string (if using a different database in production).
- `CACHE_EXPIRATION`: Duration in minutes for caching analytics data (default: 30 minutes).

### Database

The project uses SQLite by default. For production, consider using PostgreSQL or MySQL.

### Geolocation

For now this isn't optional but I intend to make it to. [API key required](https://ipapi.com) but it is free.

## Customization

Linkarooie is highly customizable:

* **Views:** Modify the HTML/CSS in the `app/views` directory.
* **Styles:** Customize the look and feel using Tailwind CSS.
* **Features:** Add or modify features in the `app/controllers` and `app/models` directories.

## Testing

Run the test suite with:

```bash
rspec
```

## Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

Please ensure your code adheres to the existing style and passes all tests.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

If you find this project helpful, please consider:

- Starring the repository on GitHub
- Sharing it with others
- Contributing to the project

## Acknowledgements

- [Ruby on Rails](https://rubyonrails.org/)
- [Tailwind CSS](https://tailwindcss.com/)
- [Docker](https://www.docker.com/)
- [DigitalOcean](https://www.digitalocean.com/)
- [Terraform](https://www.terraform.io/)

---

Linkarooie © 2024 - Simplify Your Online Presence
