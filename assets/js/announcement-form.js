import { markedWithSyntax } from './syntax-highlighting';
import { updateRecipientsPreview } from './recipients-preview';
import './vendor/select-woo';

$.fn.select2.amd.require([ 'select2/selection/search' ], (Search) => {
  // Remove tag text when deleting a tag
  // https://github.com/select2/select2/issues/3354#issuecomment-277419278
  Search.prototype.searchRemoveChoice = function(decorated, item) {
    this.trigger('unselect', {
      data: item,
    });

    this.$search.val('');
    this.handleSearch();
  };
}, null, true);

export default class {
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
      $('[data-role=markdown-preview]').html(
        'Your rendered markdown goes here'
      );
    } else {
      $('[data-role=markdown-preview]').removeClass('preview');
      const markdown = markedWithSyntax(value);
      $('[data-role=markdown-preview]').html(markdown);
    }
  }

  setupInterestsSelect() {
    const interests = $('#announcement_interests');

    if (interests.length !== 0) {
      interests.select2({
        tags: true,
        tokenSeparators: [ ',', ' ' ],
        data: window.INTEREST_NAMES.map((interest) => {
          return { 'id': interest, 'text': interest, 'selected': window.SELECTED_INTEREST_NAMES.includes(interest) };
        }),
      }).on('change.select2', (_event) => {
        const value = interests.select2('data').map((item) => item.id);

        if (!this._isEditing) {
          localStorage.setItem('interests', JSON.stringify(value) || []);
        }
        updateRecipientsPreview(value);
      });

      if (window.SELECTED_INTEREST_NAMES.length) {
        updateRecipientsPreview(window.SELECTED_INTEREST_NAMES);
      }

      if (interests.val().length === 0) {
        const localStorageValue = JSON.parse(localStorage.getItem('interests')) || [];
        interests.val(localStorageValue);
        interests.trigger('change');
      }

    }
  }

  clearLocalStorageOnSubmit() {
    if (!this._isEditing) {
      $('[data-role=announcement-form]').on('submit', function() {
        localStorage.removeItem('title');
        localStorage.removeItem('interests');
        localStorage.removeItem('markdown');
      });
    }
  }
}
