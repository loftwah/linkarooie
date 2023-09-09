import { Controller } from "stimulus";
import Sortable from "sortablejs";

export default class extends Controller {

  connect() {
    this.sortable = Sortable.create(this.element, {
      onEnd: this.end.bind(this),
    });
  }

  end(event) {
    let id = event.item.dataset.id;
    let data = new FormData();
  
    // Derive the new status from the ID of the column
    let newStatus = event.to.id.replace(/-/g, ' ').split(' ').map(word => word.charAt(0).toUpperCase() + word.slice(1)).join(' ');
    
    data.append("task[position]", event.newIndex + 1);
    data.append("task[status]", newStatus);
    
    fetch(`/tasks/${id}/move`, {
      method: "PATCH",
      body: data,
      headers: { "X-CSRF-Token": getMetaValue("csrf-token") },
    })
    .then(response => {
      if (response.ok) {
        return response.json();
      } else {
        throw new Error("Server response wasn't OK");
      }
    })
    .then(data => {
      if(data.status === "success") {
        alert("Task moved successfully"); // Notify the user with a simple alert
      } else {
        alert(`Failed to move task: ${data.message}`);
      }
    })
    .catch((error) => alert(`An error occurred: ${error.message}`));
  }
}  

// Helper function to get meta value
function getMetaValue(name) {
  const element = document.head.querySelector(`meta[name="${name}"]`);
  return element ? element.getAttribute("content") : null;
}
