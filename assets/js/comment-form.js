const resetForm = (form) => form.reset();
const disableForm = (form) => form.children(':input').attr('disabled', 'disabled');
const enableForm = (form) => form.children(':input').removeAttr('disabled');

export function setupNewForm() {
  $('.comment-form').on('submit', function submitForm(event) {
    event.preventDefault();
    const form = $(this);

    $.ajax({
      type: 'POST',
      url: form.attr('action'),
      data: form.serialize(),
      beforeSend: () => disableForm(form),
    })
    .done(() => {
      resetForm(form[0]);
      enableForm(form);
    });
  });
}
