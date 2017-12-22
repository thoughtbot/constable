const BODY_FIXED_CLASS = 'fixed';

const $body = $('body');
$body.addClass(BODY_FIXED_CLASS);

export default function() {
  watchModalClose();
  watchFormSubmit();
}

function watchFormSubmit() {
  $('.settings-form').on('submit', function(e) {
    e.preventDefault();
    const form = e.currentTarget;

    $.ajax({
      data: $(form).serialize(),
      type: 'POST',
      url: form.action,
      error: function(xhr) {
        $('.modal-container').replaceWith(xhr.responseText);
      },
      success: function(data, _status, xhr) {
        closeModal();
      },
    });
  });
}

function watchModalClose() {
  $('.modal-overlay, .modal-close').on('click', function(e) {
    e.preventDefault();
    closeModal();
  });
}

function closeModal() {
  $('.modal-container').remove();
  $body.removeClass(BODY_FIXED_CLASS);
}
