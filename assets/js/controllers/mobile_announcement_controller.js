import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["modeMarkdown", "modePreview"]

  enableMarkdown() {
    this.modeMarkdownTargets.forEach((element) => {
      element.classList.add("active")
    })

    this.modePreviewTargets.forEach((element) => {
      element.classList.remove("active")
    })
  }

  enablePreview() {
    this.modePreviewTargets.forEach((element) => {
      element.classList.add("active")
    })

    this.modeMarkdownTargets.forEach((element) => {
      element.classList.remove("active")
    })
  }
}
