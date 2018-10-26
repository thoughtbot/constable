import { Controller } from 'stimulus'

export default class extends Controller {
  load (event) {
    event.preventDefault()

    fetch(this.element.href)
      .then(response => response.text())
      .then(html => {
        document.body.appendChild(
          document.createRange().createContextualFragment(html)
        )
      })
  }
}
