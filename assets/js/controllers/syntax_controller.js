/* global MutationObserver */

import { Controller } from 'stimulus'
import { highlightCodeBlocks } from '../syntax-highlighting'

const observer = new MutationObserver(mutations => {
  mutations.forEach(() => {
    highlightCodeBlocks()
  })
})

export default class extends Controller {
  initialize () {
    observer.observe(this.element, { childList: true })
    highlightCodeBlocks()
  }
}
