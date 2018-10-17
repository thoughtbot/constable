import { Controller } from "stimulus"

const BODY_FIXED_CLASS = "fixed"

export default class extends Controller {
  initialize() {
    document.body.classList.add(BODY_FIXED_CLASS)
  }

  submit(event) {
    event.preventDefault()

    $.ajax({
      data: $(this.element).serialize(),
      type: "POST",
      url: this.element.action,
      success: (data, textStatus, jqXHR) => {
        this._closeModal()
      },
      error: (jqXHR, textStatus, errorThrown) => {
        this._showError(errorThrown)
      }
    })
  }

  close(event) {
    event.preventDefault()
    this._closeModal()
  }

  closeWithKeyboard(event) {
    var ESC_KEY = 27
    if(event.keyCode == ESC_KEY) {
      event.preventDefault()
      this._closeModal()
    }
  }

  _closeModal() {
    $(".modal-container").remove()
    document.body.classList.remove(BODY_FIXED_CLASS)
  }

  _showError(text) {
    $(".modal-container .modal-body").text(text)
  }
}
