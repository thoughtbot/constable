import { Controller } from 'stimulus'
import $ from 'jquery'
import 'selectize'

const DELIMITER = ','

export default class extends Controller {
  initialize () {
    const interests = $('#announcement_interests')

    if (interests.length !== 0) {
      if (interests.val() === '') {
        const localStorageValue = localStorage.getItem('interests')
        interests.val(localStorageValue)
        this._updateRecipientsPreview(localStorageValue)
      }

      interests.selectize({
        delimiter: DELIMITER,
        persist: false,
        create: function (name) {
          return { name }
        },
        valueField: 'name',
        labelField: 'name',
        searchField: 'name',
        options: window.INTERESTS_NAMES,
        onChange: (value) => {
          if (!this._isEditing) {
            localStorage.setItem('interests', value)
          }
          this._updateRecipientsPreview(value)
        }
      })
    }
  }

  _updateRecipientsPreview (interests) {
    const previewSelector = $('.recipients-preview')

    $.getJSON('/recipients_preview', { interests })
      .done((data) => {
        previewSelector.html(data.recipients_preview_html)
      })
  }
}
