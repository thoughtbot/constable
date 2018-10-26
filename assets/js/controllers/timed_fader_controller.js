import { Controller } from 'stimulus'
import $ from 'jquery'

export default class extends Controller {
  static targets = ['userNames']

  fadeIn () {
    const element = $(this.userNamesTarget)

    this._timer = setTimeout(function () {
      element.fadeIn(150)
    }, 150)
  }

  fadeOut () {
    const element = $(this.userNamesTarget)
    element.fadeOut(150)
    clearTimeout(this._timer)
  }
}
