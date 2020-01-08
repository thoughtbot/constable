import Mousetrap from 'mousetrap';
import { setupImageUploader } from './textarea-image-uploader';
import { autocompleteUsers } from './user-autocomplete';
import { markedWithSyntax } from './syntax-highlighting';

import socket from './socket';

const channel = socket.channel('live-html', {});

channel
  .join()
  .receive('ok', function(resp) {
    console.log('Joined successfully', resp);
  })
  .receive('error', function(resp) {
    console.log('Unable to join', resp);
  });

channel.on('new-comment', payload => {
  $(
    `[data-announcement-id='${payload.announcement_id}'] .comments-list`
  ).append(payload.comment_html);
});

const resetForm = form => form.reset();
const disableForm = form =>
  form.children(':input').attr('disabled', 'disabled');
const enableForm = form => form.children(':input').removeAttr('disabled');

const SAVE_SHORTCUT = [ 'mod+enter' ];

const initializeForm = function(usersForAutoComplete) {
  watchBody();
  watchCommentToggles();
  toggleWrite();

  setupImageUploader('#comment_body');
  autocompleteUsers('.comment-textarea', usersForAutoComplete);

  Mousetrap.bind(SAVE_SHORTCUT, function() {
    const $form = $('.comment-form');
    $form.submit();
  });
};

const initializeNewComment = () => {
  const savedComment = getCommentFromLocalStorage();
  const body = $('.comment-textarea');
  body.val(savedComment);
};

function watchBody() {
  if (!window.location.pathname.endsWith('edit')) {
    const body = $('.comment-textarea');
    body.on('input', event => {
      saveCommentToLocalStorage(event);
    });
  }
}

function getCommentFromLocalStorage() {
  return localStorage.getItem('new-markdown-comment');
}

function saveCommentToLocalStorage(event) {
  localStorage.setItem('new-markdown-comment', event.target.value);
}

function clearSavedCommentChanges() {
  localStorage.removeItem('new-markdown-comment');
}

function watchCommentToggles() {
  const viewTextButton = $('.comment-preview-text-button');
  const viewPreviewButton = $('.comment-preview-markdown-button');

  viewTextButton.on('click', toggleWrite);
  viewPreviewButton.on('click', togglePreview);
}

function toggleWrite() {
  const viewTextButton = $('.comment-preview-text-button');
  const viewPreviewButton = $('.comment-preview-markdown-button');
  const commentTextArea = $('.comment-textarea');
  const commentPreview = $('.comment-preview');
  const commentLabel = $('.comment-label');

  viewTextButton.addClass('comment-tab-button--active');
  viewPreviewButton.removeClass('comment-tab-button--active');
  commentPreview.removeClass('border-bottom');

  commentLabel.css('display', 'block');
  commentTextArea.css('display', 'block');
  commentPreview.attr('hidden', true);
}

function togglePreview() {
  updateMarkdownPreview();
  showMarkdownPreview();
}

function updateMarkdownPreview() {
  const value = $('.comment-textarea').val();
  const preview = $('.comment-preview');

  if (value.length) {
    const markdown = markedWithSyntax(value);
    preview.html(markdown);
  } else {
    preview.html('Your rendered markdown goes here');
  }
}

function showMarkdownPreview() {
  const viewTextButton = $('.comment-preview-text-button');
  const viewPreviewButton = $('.comment-preview-markdown-button');
  const commentTextArea = $('.comment-textarea');
  const commentPreview = $('.comment-preview');
  const commentLabel = $('.comment-label');

  viewTextButton.removeClass('comment-tab-button--active');
  viewPreviewButton.addClass('comment-tab-button--active');
  commentPreview.addClass('border-bottom');

  commentLabel.css('display', 'none');
  commentTextArea.css('display', 'none');
  commentPreview.removeAttr('hidden');
}

function resetPreview() {
  const commentPreview = $('.comment-preview');
  commentPreview.html('');
  toggleWrite();
}

export function setupEditForm(usersForAutoComplete) {
  initializeForm(usersForAutoComplete);
}

export function setupNewForm(usersForAutoComplete) {
  initializeForm(usersForAutoComplete);
  initializeNewComment();

  $('.comment-form').on('submit', function submitForm(event) {
    event.preventDefault();
    const form = $(this);

    $.ajax({
      type: 'POST',
      url: form.attr('action'),
      data: form.serialize(),
      beforeSend: () => disableForm(form),
    }).done(() => {
      resetForm(form[0]);
      enableForm(form);
      clearSavedCommentChanges();
      resetPreview();
    });
  });
}
