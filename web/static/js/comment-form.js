import Mousetrap from 'mousetrap';
import { setupImageUploader } from 'web/static/js/textarea-image-uploader';
import { autocompleteUsers } from 'web/static/js/user-autocomplete';

import socket from './socket'

const channel = socket.channel('live-html', {});

channel.join()
  .receive('ok', function(resp) { console.log('Joined successfully', resp) })
  .receive('error', function(resp) { console.log('Unable to join', resp) })

channel.on('new-comment', payload => {
  $(`[data-announcement-id='${payload.announcement_id}'] .comments-list`)
    .append(payload.comment_html)
})

const resetForm = (form) => form.reset();
const disableForm = (form) => form.children(':input').attr('disabled', 'disabled');
const enableForm = (form) => form.children(':input').removeAttr('disabled');

const SAVE_SHORTCUT = ['mod+enter'];

const initializeForm = function(usersForAutoComplete) {
  setupImageUploader('#comment_body');
  autocompleteUsers('.comment-textarea', usersForAutoComplete);

  Mousetrap.bind(SAVE_SHORTCUT, function() {
    const $form = $('.comment-form');
    $form.submit();
  });
}

export function setupEditForm(usersForAutoComplete) {
  initializeForm(usersForAutoComplete);
}

export function setupNewForm(usersForAutoComplete) {
  initializeForm(usersForAutoComplete);

  $('.comment-form').on('submit', function submitForm(event) {
    event.preventDefault();
    const form = $(this);

    $.ajax({
      type: 'POST',
      url: form.attr('action'),
      data: form.serialize(),
      beforeSend: () => disableForm(form),
    })
    .done(() => {
      resetForm(form[0]);
      enableForm(form);
    });
  });
}
