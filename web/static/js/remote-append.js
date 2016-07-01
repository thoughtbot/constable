$(document).on('click', '.remote-append', function(e) {
  e.preventDefault();
  const href = e.currentTarget.href;

  $.ajax({
    url: href,
    method: 'GET',
  }).done(function(data) {
    $('body').append(data);
  });
});
