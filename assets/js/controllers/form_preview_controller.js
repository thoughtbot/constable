import { Controller } from "stimulus"
import { markedWithSyntax } from "../syntax-highlighting"

export default class extends Controller {
  initialize() {
    this._isEditing = !!this.element.dataset.id
  }

  titleChange() {
    const title = $("#announcement_title")

    this._updateTitle(title.val())

    if (!this._isEditing && title.val() === "") {
      title.val(localStorage.getItem("title"))
    }
    title.trigger("input")
  }

  bodyChange() {
    const body = $("#announcement_body")

    this._updateBody(body.val())

    if (!this._isEditing && body.val() === "") {
      body.val(localStorage.getItem("markdown"))
    }

    body.trigger("input")
  }

  _updateTitle(value) {
    if (!this._isEditing) {
      localStorage.setItem("title", value)
    }

    if (value === "") {
      $("[data-role=title-preview]").addClass("preview")
      $("[data-role=title-preview]").html("Title Preview")
    } else {
      $("[data-role=title-preview]").removeClass("preview")
      $("[data-role=title-preview]").html(value)
    }
  }

  _updateBody(value) {
    if (!this._isEditing) {
      localStorage.setItem("markdown", value)
    }

    if (value === "") {
      $("[data-role=markdown-preview]").addClass("preview")
      $("[data-role=markdown-preview]").html("Your rendered markdown goes here")
    } else {
      $("[data-role=markdown-preview]").removeClass("preview")
      const markdown = markedWithSyntax(value)
      $("[data-role=markdown-preview]").html(markdown)
    }
  }
}
