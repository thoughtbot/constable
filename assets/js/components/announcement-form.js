import { markedWithSyntax } from '../lib/syntax-highlighting';
import { updateRecipientsPreview } from './recipients-preview';
import 'selectize';

const DELIMITER = ',';

export default class AnnouncementForm {
  constructor() {
    this._form = $('[data-role=announcement-form]');
    this._isEditing = !!this._form.data('id');

    this.watchTitle();
    this.watchBody();
    this.setupInterestsSelect();
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

  _updateTitle({ target: { value }}) {
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
  }

  watchBody() {
    const body = $('#announcement_body');

    body.on('input', this._updateMarkdown.bind(this));
    if (!this._isEditing && body.val() === '') {
      body.val(localStorage.getItem('markdown'));
    }

    body.trigger('input');
  }

  _updateMarkdown({ target: { value }}) {
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
  }

  setupInterestsSelect() {
    const interests = $('#announcement_interests');

    if (interests.length !== 0) {
      if (interests.val() === '') {
        const localStorageValue = localStorage.getItem('interests');
        interests.val(localStorageValue);
        updateRecipientsPreview(localStorageValue);
      }

      interests.selectize({
        delimiter: DELIMITER,
        persist: false,
        create(name) {
          return { name };
        },
        valueField: 'name',
        labelField: 'name',
        searchField: 'name',
        options: window.INTERESTS_NAMES,
        onInitialize: () => {
          this.$control_input.attr('aria-describedby', this.$input.attr('aria-describedby'));
        },
        onChange: (value) => {
          if (!this._isEditing) {
            localStorage.setItem('interests', value);
          }
          updateRecipientsPreview(value);
        },
      });
    }
  }

  clearLocalStorageOnSubmit() {
    if (!this._isEditing) {
      $('[data-role=announcement-form]').on('submit', () => {
        localStorage.removeItem('title');
        localStorage.removeItem('interests');
        localStorage.removeItem('markdown');
      });
    }
  }
}
