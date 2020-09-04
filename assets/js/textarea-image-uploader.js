import Shubox from 'shubox';

const refreshMarkdownPreview = function(inputSelector) {
  $(inputSelector).trigger('input');
};

export function setupImageUploader(selector) {
  const shuboxOptions = {
    key: window.shuboxKey,
    textBehavior: 'append',
    clickable: false,
    uploadingTemplate: '![Uploading {{name}}...]()',
    successTemplate: '![{{name}}]({{s3url}})',
    success() {
      refreshMarkdownPreview(selector);
    },
  };

  new Shubox(selector, shuboxOptions);
}
