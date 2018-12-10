import { Controller } from 'stimulus'
import $ from 'jquery'
import 'selectize'

const DELIMITER = ','

export default class extends Controller {
  initialize () {
    const interests = this._interestsElement()

    if (interests !== null) {
      if (interests.value === '') {
        const localStorageValue = localStorage.getItem('interests')
        interests.value = localStorageValue
        this._updateRecipientsPreview(localStorageValue)
      }

      $(interests).selectize({
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

  _interestsElement () {
    return document.querySelector('#announcement_interests')
  }

  _updateRecipientsPreview (interests) {
    const previewSelector = document.querySelector('.recipients-preview')

    fetch('/recipients_preview?interests=' + interests)
      .then(response => response.json())
      .then(data => {
        previewSelector.innerHTML = data.recipients_preview_html
      })
      .catch(error => {
        console.error('Error retrieving interests' + error)
      })
  }
}
