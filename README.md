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

### Roadmap

We have exciting features planned for the future. Your input can help prioritize these features. Feel free to vote on what you'd like to see implemented first!

#### Upcoming Features for Voting

1. **MPC-Style Soundboard**

   * Description: 16-button interactive soundboard to trigger .wav or .mp3 samples.

2. **Notes Section**

   * Description: A place to jot down personal notes with CRUD functionalities.

3. **Todo-List**

   * Description: Keep track of tasks with CRUD operations and status toggling.

4. **Kanban Board**

   * Description: Manage tasks in a visual, drag-and-drop interface.

5. **Weather Information**

   * Description: Fetch and display current weather based on user's location settings.

6. **Extended Icon Support on Main Page**

* Description: Handle more than 12 icons on the main page through pagination or left and right navigation arrows.

7. **Programmer Tools**

* Description: A collection of tools for programmers, such as a color picker, JSON formatter, and more.

8. **Wakatime Integration**

* Description: Display your Wakatime stats on your dashboard.

#### How to Vote

To vote, please visit our [Feature Voting Page (coming soon)](#).

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
