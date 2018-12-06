import { Controller } from 'stimulus'

const refreshMarkdownPreview = function (inputSelector) {
  const event = new Event('input', {
    'bubbles': true,
    'cancelable': true
  })
  const element = document.querySelector(inputSelector)

  element.dispatchEvent(event)
}

export default class extends Controller {
  initialize () {
    refreshMarkdownPreview(this._selector())

    const shuboxOptions = {
      textBehavior: 'append',
      clickable: false,
      s3urlTemplate: '![description of image]({{s3url}})',
      success: function () {
        refreshMarkdownPreview(this._selector())
      }
    }

    if (typeof (Shubox) !== 'undefined') {
      new Shubox(this._selector(), shuboxOptions)
    }
  }

  _selector () {
    return '#' + this.element.id
  }
}
