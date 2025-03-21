import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["template", "container", "addButton"]

  connect() {
    this.template = this.templateTarget.innerHTML
    console.log("connect")
  }

  add(event) {
    console.log("add")
    event.preventDefault()
    const content = this.template.replace(/NEW_RECORD/g, new Date().getTime())
    this.containerTarget.insertAdjacentHTML('beforeend', content)
    
    // Initialize select2 on the new product select
    const newSelect = this.containerTarget.querySelector('.select2:last-child')
    if (newSelect) {
      $(newSelect).select2()
    }
  }

  remove(event) {
    event.preventDefault()
    const wrapper = event.target.closest('.nested-fields')
    if (wrapper) {
      wrapper.remove()
    }
  }
} 