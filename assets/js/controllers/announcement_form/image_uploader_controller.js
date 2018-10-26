import { Controller } from 'stimulus'
import $ from 'jquery'

const refreshMarkdownPreview = function (inputSelector) {
  $(inputSelector).trigger('input')
}

export default class extends Controller {
  initialize () {
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
