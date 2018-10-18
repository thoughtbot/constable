import { markedWithSyntax } from './syntax-highlighting';

export default class {
  constructor() {
    this._form = $('[data-role=announcement-form]');
    this._isEditing = !!this._form.data('id');

    this.watchBody();
  }

  watchBody() {
    const body = $('#announcement_body');

    body.on('input', this._updateMarkdown.bind(this));
    if (!this._isEditing && body.val() === '') {
      body.val(localStorage.getItem('markdown'));
    }

    body.trigger('input');
  }

  _updateMarkdown(e) {
    const value = e.target.value;

    if (!this._isEditing) {
      localStorage.setItem('markdown', value);
    }

    if (value === '') {
      $('[data-role=markdown-preview]').addClass('preview');
      $('[data-role=markdown-preview]').html('Your rendered markdown goes here');
    } else {
      $('[data-role=markdown-preview]').removeClass('preview');
      const markdown = markedWithSyntax(value);
      $('[data-role=markdown-preview]').html(markdown);
    }
  };
}
