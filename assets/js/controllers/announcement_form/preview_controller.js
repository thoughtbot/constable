import { Controller } from 'stimulus'
import { markedWithSyntax } from '../../syntax-highlighting'

export default class extends Controller {
  initialize () {
    this._isEditing = !!this.element.dataset.id
  }

  titleChange () {
    const title = this._announcementTitle()
    this._updateTitle(title.value)

    if (!this._isEditing && title.value === '') {
      title.value = localStorage.getItem('title')
    }
  }

  bodyChange () {
    const body = this._announcementBody()
    this._updateBody(body.value)

    if (!this._isEditing && body.value === '') {
      body.value = localStorage.getItem('markdown')
    }
  }

  _updateTitle (value) {
    if (!this._isEditing) {
      localStorage.setItem('title', value)
    }

    const titlePreview = this._titlePreview()

    if (value === '') {
      titlePreview.classList.add('preview')
      titlePreview.innerHTML = 'Title Preview'
    } else {
      titlePreview.classList.remove('preview')
      titlePreview.innerHTML = value
    }
  }

  _updateBody (value) {
    if (!this._isEditing) {
      localStorage.setItem('markdown', value)
    }

    const bodyPreview = this._bodyPreview()

    if (value === '') {
      bodyPreview.classList.add('preview')
      bodyPreview.innerHTML = 'Your rendered markdown goes here'
    } else {
      bodyPreview.classList.remove('preview')
      const markdown = markedWithSyntax(value)
      bodyPreview.innerHTML = markdown
    }
  }

  _titlePreview () {
    return document.querySelector('[data-role=title-preview]')
  }

  _bodyPreview () {
    return document.querySelector('[data-role=markdown-preview]')
  }

  _announcementTitle () {
    return document.querySelector('#announcement_title')
  }

  _announcementBody () {
    return document.querySelector('#announcement_body')
  }
}
