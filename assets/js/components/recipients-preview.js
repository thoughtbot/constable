export const updateRecipientsPreview = (interests) => {
  $.getJSON('/recipients_preview', { interests })
    .done((data) => $('.recipients-preview').html(data.recipients_preview_html));
};
