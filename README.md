# Linkarooie

[Setup Guide](setup.md) | [Developer Guide](developer_guide.md)

![Linkarooie](https://github.com/loftwah/linkarooie/assets/19922556/80761b49-752b-45dd-b910-e92c68411bc0)

## Overview

Linkarooie is your go-to, Ruby on Rails-powered web dashboard, perfect for setting as your browser's homepage. Why settle for a standard, uninspiring start page when you can customize your own digital launchpad? From managing vital links to personalizing aesthetics, Linkarooie not only simplifies your web experience but also serves as an invaluable learning platform for Ruby on Rails enthusiasts.

### Get Started with Linkarooie: Your Personalized Web Jump-Off Point

Whether you're a casual browser or a full-stack developer, Linkarooie offers you a richer, more interactive starting point for your web ventures. Hop on board and hop your way through the web!

### What is it though?

Imagine your computer's web browser is like a magic carpet that can take you to all sorts of places on the internet. But every time you get on that carpet, it starts at a very plain and boring spot, like an empty room.

Linkarooie changes that. It's like decorating that empty room with all your favorite things. You can add shortcuts to your favorite websites, like a treasure chest that holds maps to your favorite places. You can even change how the room looks by picking your favorite colors or putting up a cool picture.

So, every time you start your magic carpet (web browser), you'll see this awesome room (Linkarooie dashboard) first. It makes going on internet adventures way more fun and easy!

And the coolest part? Linkarooie is like a toy you can build and change yourself because it's made with something called Ruby on Rails, which is a set of building blocks for making websites. So, you can learn how to add more cool stuff to your room while you use it!

![Linkarooie Screenshot](https://github.com/loftwah/linkarooie/assets/19922556/f1a120cb-cb3c-4d4f-bbba-a00e8415289d)

### Built With

🔨 These are the tools that make Linkarooie awesome:

* **Ruby 3.2.2**: The heart and soul, powering our back-end logic.
* **Ruby on Rails**: The sturdy framework that holds everything together.
* **Bootstrap 5**: Making sure Linkarooie looks good in all its glory.
* **Stimulus**: Adding that sprinkle of interactivity.
* **Hotwire**: Real-time updates without breaking a sweat.
* **SortableJS**: For that slick drag-and-drop on the Kanban board.
* **AWS Services**: Where Linkarooie calls home.
* **GitHub Actions**: Our trusty builder and tester.
* **Ubuntu 22.04**: The rock-solid base of our production environment.

## Features

* **Add Links**: Easily add links to your dashboard that open in a new window.
* **Pin Links**: Highlight essential links for easy access.
* **Customization**: Change the background color and add a background image to personalize your dashboard.
* **User Management**: Sign up and manage your customized dashboard settings.
* **Kanban Board**: Manage tasks in a visual, drag-and-drop interface.

### Roadmap

We have exciting features planned for the future. Your input can help prioritize these features. Feel free to vote on what you'd like to see implemented first!

#### Upcoming Features for Voting

1. **MPC-Style Soundboard**

   * Description: 16-button interactive soundboard to trigger .wav or .mp3 samples.

2. **Notes Section**

   * Description: A place to jot down personal notes with CRUD functionalities.

3. **Weather Information**

   * Description: Fetch and display current weather based on user's location settings.

4. **Extended Icon Support on Main Page**

    * Description: Handle more than 12 icons on the main page through pagination or left and right navigation arrows.

5. **Wakatime Integration**

    * Description: Display your Wakatime stats on your dashboard.

6. **Sorting options for Links/Count how many times a link has been clicked**

    * Description: Sort links by name, date added, or pinned status.

7. **Display stats somewhere on the page**

    * Description: Display stats such as the number of links, number of pinned links, and number of times a link has been clicked. This could be the same place as the weather information and Wakatime integration.

8. **SAML/SSO Authentication**

    * Description: Authenticate with SAML/SSO.

9. **GitHub OAuth**

    * Description: Authenticate with GitHub OAuth.

10. **Twitter Stats Dashboard**

    * Description: Display key metrics from your Twitter account, including followers growth, tweet impressions, engagement rates, and a summary of recent posts. Features options for different time views (from 7 days to 1 year) and downloading sections as CSV. Integrates with Twitter via OAuth.

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
