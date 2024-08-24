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

### Backup and Restore Process

Linkarooie includes an automated backup system to ensure that your SQLite database is securely stored and easily recoverable. This process is managed using a combination of scheduled jobs and DigitalOcean Spaces for storage.

#### Automated Backups

The `BackupDatabaseJob` is scheduled to run daily at 2 AM, ensuring that your SQLite database is backed up regularly. The backup process involves the following steps:

1. **Database Dump**: The job creates a dump of the current SQLite database, storing it in the `db/backups` directory with a timestamp and environment identifier.
2. **Upload to DigitalOcean Spaces**: The backup file is then uploaded to a DigitalOcean Spaces bucket, where it is securely stored with versioning enabled. This ensures that previous versions of the backup are retained for a short period, allowing you to restore from a specific point in time if needed.
3. **Cleanup**: Optionally, the local backup file is deleted after it has been successfully uploaded to DigitalOcean Spaces.

#### Restoring from a Backup

In the event that you need to restore your database from a backup, you can use the provided Rake task. This task allows you to specify the backup file you want to restore from and automatically loads it into the SQLite database.

**Restoration Steps:**

1. **Run the Restore Task**: Use the following command, specifying the path to your backup file:

   ```bash
   rake db:restore BACKUP_FILE=path/to/your_backup_file.sql
   ```

2. **Process Overview**:

   * The task will first drop all existing tables in the database to ensure a clean restoration.
   * It will then load the specified backup file into the database.
   * Upon completion, your database will be restored to the state it was in when the backup was created.

3. **Error Handling**: If the backup file is not provided or if any errors occur during the restoration process, the task will output helpful messages to guide you in resolving the issue.

#### Important Notes

* **Environment-Specific Backups**: Backups are created separately for each environment (development, production, test), and the backup files are named accordingly.
* **DigitalOcean Spaces Configuration**: Ensure that your DigitalOcean API credentials and bucket details are correctly configured in your environment variables for the backup and restore processes to function properly.
* **Testing Restores**: Regularly test the restore process in a development environment to ensure that your backups are reliable and that the restore process works as expected.

### Geolocation

Currently, geolocation functionality is mandatory, but I plan to make it optional in future updates. To enable geolocation, you will need an [API key from ipapi](https://ipapi.com), which is free to obtain.

## Gather.sh

I wrote a script to gather information that is useful to copy paste into things like ChatGPT or Cluade.

```bash
➜  linkarooie git:(dl/public-analytics-page) ✗ ./gather.sh --help
Usage: ./gather.sh [-o output_method] [-f output_file]
  -o, --output         Output method: stdout, clipboard, or file (default: stdout)
  -f, --file           Output file path (required if output method is file)
  ```

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
