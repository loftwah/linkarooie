# Twitter/X Dashboard

## 1. **OAuth Authentication with Twitter**:

* Use `omniauth-twitter` gem to authenticate users with Twitter.

## 2. **Fetching and Storing Twitter Stats**:

### **User Profile Information**:

* **Avatar, Name, Username**: When authenticating, store these in your user model.

### **Time Frame Filtering**:

* Introduce a dropdown or a set of buttons to allow users to select the desired time frame (7 days, 14 days, etc.)

### **Followers**:

* **Cumulative**: Store the total follower count each day for a user.
* **Daily**: Calculate the difference in followers each day.
* **Graph**: Use the `Chartkick` gem along with the `groupdate` gem to easily produce line graphs for Rails.

### **Impressions**:

* Store the number of tweet impressions for each day.
* **Graph**: Bar chart using `Chartkick`.

### **Engagement Rate & Engagements**:

* Store total engagements and calculate engagement rate (engagements/impressions \* 100).
* **Graph**: Bar chart using `Chartkick`.

### **Profile Conversion Rate**:

* Store and calculate the conversion rate. (profile visits/impressions \* 100)

### **Posts**:

* Breakdown the posts into Posts & Threads, Threads, and Replies.
* Use a data table (gem like `datatable` or frontend library like `DataTables`) to display these in a tabular format, sortable and searchable.

## 3. **Downloading Data**:

* For sections that need downloadable data, implement CSV exports. Rails has built-in CSV support, so you can have endpoints that respond to CSV format.

## 4. **Database & Background Jobs**:

* Considering the extensive time frame options, you'll be storing a good amount of data for each user. Periodically, run background jobs (using `Sidekiq` or `ActiveJob`) to fetch and update this data.

## 5. **Frontend**:

* **Rails Views**: Use partials for each section to keep code modular.
* **Styling**: Use Bootstrap or any other frontend framework to style the dashboard.
* **JavaScript**: Use vanilla JS or a lightweight library like AlpineJS for interactivity, such as changing time frames or toggling between metrics.

## 6. **Tests**:

* Add tests to ensure data retrieval and calculation logic is correct.
* Consider using tools like VCR for testing interactions with external services like Twitter.

## 7. **Opt-out & Privacy**:

* As previously noted, ensure users can disconnect their Twitter and be clear about the data being fetched.

When you're ready to extend functionalities or add further insights, you can always build upon this foundation. Remember to ensure your application respects Twitter's API usage terms and rate limits.
