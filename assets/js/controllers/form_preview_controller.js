import { Controller } from "stimulus"

export default class extends Controller {
  titleChange() {
    const title = $('#announcement_title')

    this._updateTitle(this.element.value)

    if (!this._isEditing && title.val() === '') {
      title.val(localStorage.getItem('title'))
    }
    title.trigger('input')
  }

  _updateTitle(value) {
    if (!this._isEditing) {
      localStorage.setItem('title', value)
    }

    if (value === '') {
      $('[data-role=title-preview]').addClass('preview')
      $('[data-role=title-preview]').html('Title Preview')
    } else {
      $('[data-role=title-preview]').removeClass('preview')
      $('[data-role=title-preview]').html(value)
    }
  }
}
