// app/javascript/controllers/kanban_controller.js

import { Controller } from "stimulus";
import Sortable from "sortablejs";

export default class extends Controller {
  connect() {
    console.log("Stimulus controller connected"); // Debugging

    // Check if the element is correctly initialized
    if (!this.element) {
      console.error("Stimulus element not found");
      return;
    }

    // Get all the '.kanban-col' elements inside this controller's element
    this.kanbanCols = Array.from(this.element.querySelectorAll(".kanban-col"));

    // Initialize Sortable on each '.kanban-col' element
    this.kanbanCols.forEach((col) => {
      Sortable.create(col.querySelector('.kanban-col-items'), {
        group: 'kanban',
        sort: true,
        animation: 150,
        onEnd: this.end.bind(this),
        onStart: () => { console.log("Drag started"); }, // Debugging
        onSort: () => { console.log("Element sorted"); }, // Debugging
      });
    });

    console.log("Sortable instances created"); // Debugging
  }

  end(event) {
    console.log("Drag and Drop event fired"); // Debugging

    // Check if all expected data attributes are present
    if (!event.item || !event.item.dataset || !event.to || !event.to.closest('.kanban-col').dataset || !this.element || !this.element.dataset) {
      console.error("Missing essential data attributes:", event, this.element);
      return;
    }

    let id = event.item.dataset.itemId;
    let new_col_id = event.to.closest('.kanban-col').dataset.colId;
    let kanban_id = this.element.dataset.id;

    console.log(`Moving card ${id} to column ${new_col_id} in kanban ${kanban_id}`); // Debugging
  
    fetch(`/kanbans/${kanban_id}/move`, {
      method: 'PATCH',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector("meta[name='csrf-token']").content
      },
      body: JSON.stringify({ card_id: id, new_col_id: new_col_id }),
    })
    .then(response => response.json())
    .then(data => {
      console.log("Server responded with:", data); // Debugging
    })
    .catch(err => {
      console.error("Fetch failed:", err); // Debugging
    });
  }
}
