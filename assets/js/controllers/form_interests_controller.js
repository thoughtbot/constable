import { Controller } from "stimulus"
import { updateRecipientsPreview } from "../recipients-preview"
import "selectize"

const DELIMITER = ","

export default class extends Controller {
  initialize() {
    const interests = $("#announcement_interests")

    if (interests.length !== 0) {
      if (interests.val() === '') {
        const localStorageValue = localStorage.getItem('interests')
        interests.val(localStorageValue)
        updateRecipientsPreview(localStorageValue)
      }

      interests.selectize({
        delimiter: DELIMITER,
        persist: false,
        create: function(name) {
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
          updateRecipientsPreview(value)
        },
      })
    }
  }
}
