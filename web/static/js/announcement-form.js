import $ from 'jquery';
import marked from 'marked';
import 'selectize';

const DELIMITER = ',';

const watchTitle = function() {
  const title = $('#announcement_title');

  title.on('input', updateTitle);
  title.val(localStorage.getItem('title'));
  title.trigger('input');
}

const watchBody = function() {
  const body = $('#announcement_body');

  body.on('input', updateMarkdown);
  body.val(localStorage.getItem('markdown'));
  body.trigger('input');
}

const setupInterestsSelect = function() {
  const interests = $('#announcement_interests');

  if (interests.lenth !== 0) {
    interests.val(localStorage.getItem('interests'));

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
        localStorage.setItem('interests', value);
      },
    });
  }
}

const updateTitle = function(e) {
  const value = e.target.value;
  localStorage.setItem('title', value);

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
  localStorage.setItem('markdown', value);

  if (value === '') {
    $('[data-role=markdown-preview]').addClass('preview');
    $('[data-role=markdown-preview]').html('Your rendered markdown goes here');
  } else {
    $('[data-role=markdown-preview]').removeClass('preview');

    const markdown = marked(value);
    $('[data-role=markdown-preview]').html(markdown);
  }
};

export function setupForm() {
  watchTitle();
  watchBody();
  setupInterestsSelect();
}
