const refreshMarkdownPreview = function(inputSelector) {
  $(inputSelector).trigger('input');
};

export function setupImageUploader(selector) {
  const shuboxOptions = {
    textBehavior: 'append',
    clickable: false,
    s3urlTemplate: '![description of image]({{s3url}})',
    success: function() {
      refreshMarkdownPreview(selector);
    },
  }

  new Shubox(selector, shuboxOptions);
}
