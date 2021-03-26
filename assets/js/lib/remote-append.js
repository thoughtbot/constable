$(document).on('click', '.remote-append', (event) => {
  event.preventDefault();

  $.ajax({
    url: event.currentTarget.href,
    method: 'GET',
  }).done((data) => $('body').append(data));
});
