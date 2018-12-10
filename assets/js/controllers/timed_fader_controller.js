import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = ['userNames']

  fadeIn () {
    const element = this.userNamesTarget
    element.classList.remove('fade-out')
    element.classList.add('fade-in')
  }

  fadeOut () {
    const element = this.userNamesTarget
    element.classList.remove('fade-in')
    element.classList.add('fade-out')
  }
}
