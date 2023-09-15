import '@popperjs/core';
import 'bootstrap'
import 'controllers'

document.addEventListener("turbolinks:load", () => {
    const navbarToggle = document.getElementById("navbarToggle");
    const navbarMenu = document.getElementById("navbarNav");
  
    if (navbarToggle && navbarMenu) {
      navbarToggle.addEventListener("click", () => {
        navbarMenu.classList.toggle("show");
      });
    }
  });  

  document.addEventListener('turbolinks:load', () => {
    const kanbanUls = document.querySelectorAll(".kanban .kanban-col");
    if (kanbanUls) {
      initKanbanSortable(kanbanUls);
    }
  });