# Linkarooie Developer Guide 🦘

- - -

## Overview

🌟 Welcome to the Linkarooie Developer Guide! Linkarooie is your go-to dashboard for personalizing your web experience. Crafted with love using Ruby on Rails, this custom dashboard lets you manage links, customize your board, and even plan your day with a Kanban board. Let's hop right in! 🦘

- - -

## Built With

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

- - -

## Getting Started

🚀 To hop on board, make sure you've got the following:

### Prerequisites

* Ruby 3.2.2
* Yarn
* PostgreSQL (for production)

### Installation

1. Clone the repo: `git clone https://github.com/yourrepo/linkarooie.git`
2. Install dependencies: `bundle install && yarn install`
3. Set up the database: `rails db:create db:migrate`
4. Start the server: `rails s`

- - -

## Architecture

### Ruby on Rails

🛤️ Our back-end is Rails. We follow the standard MVC architecture.

### Stimulus

⚡ Handles our client-side logic. We use it for form validations, pinning links, and more.

### Hotwire

🔥 For those real-time updates. Primarily used in the Notes and Kanban sections.

### Bootstrap

🎨 For the beauty. We use Bootstrap's Grid, Cards, and Forms.

- - -

## Features

### UI Components

🎏 We use Bootstrap to design our dashboard, forms, and modals.

### Client-side Interactivity

🎮 Stimulus is our go-to for any interactive elements, including adding and pinning links.

#### Stimulus Controller for Adding Links

```javascript
# app/javascript/controllers/add_link_controller.js
import { Controller } from "stimulus"

export default class extends Controller {
  addLink(event) {
    event.preventDefault()
    // AJAX logic to add a link
  }
}
```

### Real-Time Updates

⚡ We use Hotwire to make our Notes section and Kanban board real-time.

#### Hotwire for Notes Section

```html
<!-- app/views/notes/index.html.erb -->
<turbo-frame id="notes">
  <% @notes.each do |note| %>
    <%= note.content %>
  <% end %>
</turbo-frame>
```

### Kanban Board

📋 Our Kanban board uses Stimulus for logic and SortableJS for drag-and-drop functionality.

#### Stimulus + SortableJS for Kanban

```javascript
// app/javascript/controllers/kanban_controller.js
import { Controller } from "stimulus"
import Sortable from "sortablejs"

export default class extends Controller {
  connect() {
    this.sortable = Sortable.create(this.element, {
      onUpdate: this.handleUpdate.bind(this)
    })
  }

  handleUpdate(event) {
    // AJAX logic to update the new order
  }
}
```

- - -

## Testing

🧪 Focused on AWS integration tests, because Linkarooie calls AWS home. We use GitHub Actions to run our test suite.

- - -

## Deployment

🚢 We deploy Linkarooie using AWS services and our CI/CD pipeline is managed through GitHub Actions.

- - -

## Contributing

🤝 Contributions are what make the Linkarooie community an amazing place. Feel free to fork and hop in! I will try to get to issues and PRs as best I can but I can't promise anything.

- - -

## License

📄 MIT License. Do what you want, but do it responsibly.

- - -

## Contact

📧 For any inquiries or issues, ping us on GitHub or shoot us an email.

- - -

🎉 **That's all, folks! Hop on and let's make the web a better place with Linkarooie!** 🦘

- - -