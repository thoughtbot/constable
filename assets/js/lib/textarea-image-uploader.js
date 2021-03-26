import Shubox from 'shubox';

const refreshMarkdownPreview = (inputSelector) => {
  $(inputSelector).trigger('input');
};

export const setupImageUploader = (selector) => {
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

  if (typeof(Shubox) !== 'undefined') {
    new Shubox(selector, shuboxOptions);
  }
};
