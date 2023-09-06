# Linkarooie

![Linkarooie](https://github.com/loftwah/linkarooie/assets/19922556/82607b81-2a75-4f79-bc16-803eca08f612)

## Overview

This custom dashboard is a Ruby on Rails application developed for personal use and serves as a learning platform for Ruby on Rails. The dashboard is designed to be the default page that opens up in your web browser. It features the capability to manage links and customize the look and feel to match your preferences.

![Screenshot of Linkarooie](https://github.com/loftwah/linkarooie/assets/19922556/c2e91925-cd1c-444e-9b21-77fb8ae41f6d)

### Built With

* Ruby 3.2.2
* Ruby on Rails
* SQLite Database (PostgreSQL in production coming soon)
* AWS Services (coming soon)
* GitHub Actions
* Ubuntu 22.04
* HTMX (coming soon)

## Features

* **Add Links**: Easily add links to your dashboard that open in a new window.
* **Pin Links**: Highlight essential links for easy access.
* **Customization**: Change the background color and add a background image to personalize your dashboard.
* **User Management**: Sign up and manage your customized dashboard settings.

### Upcoming Features

1. **MPC-Style Soundboard**

   * 16 interactive buttons to trigger .wav or .mp3 samples.
   * Ability to easily add new preset folders with sound files.

2. **Notes Section**

   * Create, Read, Update, and Delete (CRUD) functionality for personal notes.

3. **Todo-List**

   * Task creation with CRUD operations.
   * Toggle task status between completed and not completed.

4. **Kanban Board**

   * Create tasks and move them through customizable stages.
   * Drag-and-drop interface for ease of use.

5. **Weather Information**

   * Fetch and display current weather based on user location settings.
   * Utilize Redis to cache weather data and minimize API calls.

## Getting Started

### Prerequisites

* Ruby 3.2.2
* Ruby on Rails
* SQLite
* NodeJS
* Yarn

### Installation

1. Clone the repository.

    ```bash
    git clone https://github.com/loftwah/linkarooie.git
    ```
    
2. Navigate to the project directory.

    ```bash
    cd linkarooie
    ```

3. Install dependencies.

    ```bash
    bundle install
    yarn install
    ```

4. Create and migrate the database.

    ```bash
    rails db:create db:migrate db:seed
    rails assets:precompile
    ```

5. Start the Rails server.

    ```bash
    rails s
    ```

Visit `http://localhost:3000` to view your custom dashboard.

- The default username is `loftwah@linkarooie.com` and the default password is `Password01`.

## Usage

To add links, sign up and navigate to your dashboard settings. Here, you can manage and pin links, as well as customize your dashboard's appearance.

## GitHub Actions Workflow

All code changes are automatically tested using GitHub Actions, focusing on region-specific AWS integration tests. So far basic RSpec tests have been implemented. More tests will be added in the future. Continuous deployment is also planned for the future.

## Contributing

This project is for personal use and learning. Feel free to fork and use it as a base for your custom dashboard.

## License

MIT License. See `LICENSE` for more information.
