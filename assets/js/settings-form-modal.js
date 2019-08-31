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
      error(xhr) {
        $('.modal-container').replaceWith(xhr.responseText);
      },
      success(_data, _status, _xhr) {
        closeModal();
      },
    });
  });
}

function watchModalClose() {
  $(document).keyup(function(e) {
    if (e.keyCode == 27) {
      e.preventDefault();
      closeModal();
    }
  });
  $('.modal-overlay, .modal-close').on('click', function(e) {
    e.preventDefault();
    closeModal();
  });
}

function closeModal() {
  $('.modal-container').remove();
  $body.removeClass(BODY_FIXED_CLASS);
}
