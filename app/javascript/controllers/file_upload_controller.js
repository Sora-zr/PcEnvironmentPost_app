import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="file-upload"
export default class extends Controller {
  static targets = ['fileUpload']

  connect() {
  }

  dragover(e) {
    e.preventDefault()
  }

  drop(e) {
    e.preventDefault()

    const files = e.dataTransfer.files
    if (typeof  files[0] !== 'undefined') {
      this.fileUploadTarget.files = files
    }
  }
}
