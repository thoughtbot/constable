import { Controller } from "stimulus"
import Mousetrap from "mousetrap"

const SAVE_SHORTCUT = ["mod+enter"]

export default class extends Controller {
  initialize() {
    const form = this.element

    Mousetrap.bind(SAVE_SHORTCUT, function() {
      form.submit()
    })
  }
}
