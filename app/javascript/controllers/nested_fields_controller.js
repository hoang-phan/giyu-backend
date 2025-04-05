import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container", "template"]

  connect() {
    console.log("NestedFieldsController connected")
    this.content = this.templateTarget.querySelector('.nested-fields').outerHTML;
    this.templateTarget.remove();
    this.nextIndex = this.containerTarget.querySelectorAll('.nested-fields').length;
  }

  add(event) {
    event.preventDefault()
    const content = this.content.replace(/{INDEX}/g, this.nextIndex);
    this.containerTarget.insertAdjacentHTML('beforeend', content);
    this.nextIndex++;
  }

  remove(event) {
    event.preventDefault()
    const wrapper = event.target.closest('.nested-fields')
    if (wrapper) {
      // If this is a new record, just remove it
      if (!Number(wrapper.querySelector('input[name*="[id]"]')?.value)) {
        wrapper.remove()
      } else {
        // If this is an existing record, mark it for destruction
        const destroyInput = wrapper.querySelector('input[type="checkbox"][name*="[_destroy]"]')
        if (destroyInput) {
          destroyInput.checked = true
          wrapper.style.display = 'none'
        }
      }
    }
  }
} 