import { Controller } from "stimulus"

export default class extends Controller {
  clearValues() {
    localStorage.removeItem('title')
    localStorage.removeItem('interests')
    localStorage.removeItem('markdown')
  }
}
