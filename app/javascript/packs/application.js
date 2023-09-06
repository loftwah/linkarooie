import '@popperjs/core';
import 'bootstrap'

document.addEventListener("turbolinks:load", () => {
    const navbarToggle = document.getElementById("navbarToggle");
    const navbarMenu = document.getElementById("navbarNav");
  
    if (navbarToggle && navbarMenu) {
      navbarToggle.addEventListener("click", () => {
        navbarMenu.classList.toggle("show");
      });
    }
  });  
  