const refreshMarkdownPreview = function(inputSelector) {
  $(inputSelector).trigger('input');
};

export function setupImageUploader(selector) {
  const shuboxOptions = {
    textBehavior: 'append',
    clickable: false,
    s3urlTemplate: '![description of image]({{s3url}})',
    success() {
      refreshMarkdownPreview(selector);
    },
  };

  if (typeof(Shubox) !== 'undefined') {
    new Shubox(selector, shuboxOptions);
  }
}
