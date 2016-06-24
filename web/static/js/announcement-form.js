import { markedWithSyntax } from './syntax-highlighting';
import { updateRecipientsPreview } from './recipients-preview';
import 'selectize';

const DELIMITER = ',';

const watchTitle = function() {
  const title = $('#announcement_title');

  title.on('input', updateTitle);
  title.trigger('input');
}

const watchBody = function() {
  const body = $('#announcement_body');
  body.on('input', updateMarkdown);
  body.trigger('input');
}

const setupInterestsSelect = function() {
  const interests = $('#announcement_interests');

  if (interests.length !== 0) {
    interests.selectize({
      delimiter: DELIMITER,
      persist: false,
      create: function(name) {
        return { name };
      },
      valueField: 'name',
      labelField: 'name',
      searchField: 'name',
      options: window.INTERESTS_NAMES,
      onChange: function(value) {
        updateRecipientsPreview(value);
      },
    });
  }
}

const updateTitle = function(e) {
  const value = e.target.value;

  if (value === '') {
    $('[data-role=title-preview]').addClass('preview');
    $('[data-role=title-preview]').html('Title Preview');
  } else {
    $('[data-role=title-preview]').removeClass('preview');
    $('[data-role=title-preview]').html(value);
  }
};

const updateMarkdown = function(e) {
  const value = e.target.value;

  if (value === '') {
    $('[data-role=markdown-preview]').addClass('preview');
    $('[data-role=markdown-preview]').html('Your rendered markdown goes here');
  } else {
    $('[data-role=markdown-preview]').removeClass('preview');
    const markdown = markedWithSyntax(value);
    $('[data-role=markdown-preview]').html(markdown);
  }
};

export function setupForm() {
  watchTitle();
  watchBody();
  setupInterestsSelect();
}
