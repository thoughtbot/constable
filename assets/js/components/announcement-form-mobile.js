export const setupForm = () => {
  const markdownHeader = $('.header-tag-markdown');
  const previewHeader = $('.header-tag-preview');
  const markdownContainer = $('.announcement-create');
  const previewContainer = $('.announcement-preview');

  markdownHeader.on('click', () => {
    markdownHeader.addClass('active');
    previewHeader.removeClass('active');

    markdownContainer.addClass('active');
    previewContainer.removeClass('active');
  });

  previewHeader.on('click', () => {
    previewHeader.addClass('active');
    markdownHeader.removeClass('active');

    previewContainer.addClass('active');
    markdownContainer.removeClass('active');
  });
};
