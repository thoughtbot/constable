import { Controller } from 'stimulus'
import $ from 'jquery'

const resetForm = (form) => form.reset()
const disableForm = (form) => form.children(':input').attr('disabled', 'disabled')
const enableForm = (form) => form.children(':input').removeAttr('disabled')

export default class extends Controller {
  initialize () {
    this._initialized = true
  }

  submit (event) {
    if (this._initialized) {
      event.preventDefault()
      const form = $(this.element.querySelector('form'))

      $.ajax({
        type: 'POST',
        url: form.attr('action'),
        data: form.serialize(),
        beforeSend: () => disableForm(form)
      })
        .done(() => {
          resetForm(form[0])
          enableForm(form)
        })
    }
  }
}
