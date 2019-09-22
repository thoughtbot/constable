export function updateRecipientsPreview(interests) {
  const previewSelector = '.recipients-preview';
  $.getJSON('/recipients_preview', { interests: interests.join(',') })
    .done((data) => {
      $(previewSelector).html(data.recipients_preview_html);
    });
}
