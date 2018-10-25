import { Controller } from "stimulus"

const resetForm = (form) => form.reset()
const disableForm = (form) => form.children(':input').attr('disabled', 'disabled')
const enableForm = (form) => form.children(':input').removeAttr('disabled')

export default class extends Controller {
  submit(event) {
    event.preventDefault()
    const form = $(this.element)

    $.ajax({
      type: 'POST',
      url: form.attr('action'),
      data: form.serialize(),
      beforeSend: () => disableForm(form),
    })
    .done(() => {
      resetForm(form[0])
      enableForm(form)
    })
  }
}
