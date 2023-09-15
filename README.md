# Linkarooie

![Linkarooie](https://github.com/loftwah/linkarooie/assets/19922556/80761b49-752b-45dd-b910-e92c68411bc0)

## Overview

This custom dashboard is a Ruby on Rails application developed for personal use and serves as a learning platform for Ruby on Rails. The dashboard is designed to be the default page that opens up in your web browser. It features the capability to manage links and customize the look and feel to match your preferences.

![Linkarooie Screenshot](https://github.com/loftwah/linkarooie/assets/19922556/f1a120cb-cb3c-4d4f-bbba-a00e8415289d)

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

    * Description: A collection of tools for programmers, such as a color picker, JSON formatter, encoder/decoder, key generator, DNS lookup and WHOIS and more.

8. **Wakatime Integration**

    * Description: Display your Wakatime stats on your dashboard.

9. **Sorting options for Links/Count how many times a link has been clicked**

    * Description: Sort links by name, date added, or pinned status.

10. **Display stats somewhere on the page**

    * Description: Display stats such as the number of links, number of pinned links, and number of times a link has been clicked. This could be the same place as the weather information and Wakatime integration.

11. **Subnet Calculator**

    * Description: A subnet calculator to calculate subnet masks, IP addresses, and more.

12. **SAML/SSO Authentication**

    * Description: Authenticate with SAML/SSO.

13. **GitHub OAuth**

    * Description: Authenticate with GitHub OAuth.

14. **Twitter Stats Dashboard**

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

## Twitter/X Dashboard

### 1. **OAuth Authentication with Twitter**:

* Use `omniauth-twitter` gem to authenticate users with Twitter.

### 2. **Fetching and Storing Twitter Stats**:

#### **User Profile Information**:

* **Avatar, Name, Username**: When authenticating, store these in your user model.

#### **Time Frame Filtering**:

* Introduce a dropdown or a set of buttons to allow users to select the desired time frame (7 days, 14 days, etc.)

#### **Followers**:

* **Cumulative**: Store the total follower count each day for a user.
* **Daily**: Calculate the difference in followers each day.
* **Graph**: Use the `Chartkick` gem along with the `groupdate` gem to easily produce line graphs for Rails.

#### **Impressions**:

* Store the number of tweet impressions for each day.
* **Graph**: Bar chart using `Chartkick`.

#### **Engagement Rate & Engagements**:

* Store total engagements and calculate engagement rate (engagements/impressions \* 100).
* **Graph**: Bar chart using `Chartkick`.

#### **Profile Conversion Rate**:

* Store and calculate the conversion rate. (profile visits/impressions \* 100)

#### **Posts**:

* Breakdown the posts into Posts & Threads, Threads, and Replies.
* Use a data table (gem like `datatable` or frontend library like `DataTables`) to display these in a tabular format, sortable and searchable.

### 3. **Downloading Data**:

* For sections that need downloadable data, implement CSV exports. Rails has built-in CSV support, so you can have endpoints that respond to CSV format.

### 4. **Database & Background Jobs**:

* Considering the extensive time frame options, you'll be storing a good amount of data for each user. Periodically, run background jobs (using `Sidekiq` or `ActiveJob`) to fetch and update this data.

### 5. **Frontend**:

* **Rails Views**: Use partials for each section to keep code modular.
* **Styling**: Use Bootstrap or any other frontend framework to style the dashboard.
* **JavaScript**: Use vanilla JS or a lightweight library like AlpineJS for interactivity, such as changing time frames or toggling between metrics.

### 6. **Tests**:

* Add tests to ensure data retrieval and calculation logic is correct.
* Consider using tools like VCR for testing interactions with external services like Twitter.

### 7. **Opt-out & Privacy**:

* As previously noted, ensure users can disconnect their Twitter and be clear about the data being fetched.

When you're ready to extend functionalities or add further insights, you can always build upon this foundation. Remember to ensure your application respects Twitter's API usage terms and rate limits.

## Contributing

This project is for personal use and learning. Feel free to fork and use it as a base for your custom dashboard.

## License

MIT License. See `LICENSE` for more information.
