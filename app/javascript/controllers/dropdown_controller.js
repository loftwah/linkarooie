import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "menu" ]

  connect() {
    console.log("Dropdown controller connected", this.element)
    console.log("Menu target:", this.menuTarget)
  }

  toggle() {
    console.log("Toggle called")
    if (this.hasMenuTarget) {
      console.log("Menu target found, toggling visibility")
      this.menuTarget.classList.toggle('hidden')
    } else {
      console.error("Menu target not found")
    }
  }

  hide(event) {
    if (!this.element.contains(event.target)) {
      console.log("Hiding dropdown")
      this.menuTarget.classList.add('hidden')
    }
  }
}