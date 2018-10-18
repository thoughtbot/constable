import { markedWithSyntax } from './syntax-highlighting';

export default class {
  constructor() {
    this._form = $('[data-role=announcement-form]');
    this._isEditing = !!this._form.data('id');

    this.watchTitle();
    this.watchBody();
    this.clearLocalStorageOnSubmit();
  }

  watchTitle() {
    const title = $('#announcement_title');

    title.on('input', this._updateTitle.bind(this));

    if (!this._isEditing && title.val() === '') {
      title.val(localStorage.getItem('title'));
    }
    title.trigger('input');
  }

  _updateTitle(e) {
    const value = e.target.value;

    if (!this._isEditing) {
      localStorage.setItem('title', value);
    }

    if (value === '') {
      $('[data-role=title-preview]').addClass('preview');
      $('[data-role=title-preview]').html('Title Preview');
    } else {
      $('[data-role=title-preview]').removeClass('preview');
      $('[data-role=title-preview]').html(value);
    }
  };

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

  clearLocalStorageOnSubmit() {
    if (!this._isEditing) {
      $('[data-role=announcement-form]').on('submit', function() {
        localStorage.removeItem('title');
        localStorage.removeItem('interests');
        localStorage.removeItem('markdown');
      });
    }
  };
}
