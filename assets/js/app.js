import css from '../css/app.scss';

// Framework JS
import 'phoenix_html';

// Basic AJAX Helper
import './lib/remote-append';

// Load components
import './checkbox-switch';

// Bring in jQuery for other modules that rely on it
import $ from 'jquery';
window.jQuery = $;
window.$ = $;

// Set up turbolinks
import TurboLinks from 'turbolinks';
TurboLinks.start();

// Set up local-time
import LocalTime from 'local-time';
LocalTime.start();

import NProgress from 'nprogress';
window.addEventListener('phx:page-loading-start', info => NProgress.start());
window.addEventListener('phx:page-loading-stop', info => NProgress.done());

import * as commentForm from './components/comment-form';
import * as syntaxHighlighting from './lib/syntax-highlighting';
import * as announcementForm from './components/announcement-form';
import * as announcementFormMobile from './components/announcement-form-mobile';
import * as textareaImageUploader from './lib/textarea-image-uploader';
import * as userAutocomplete from './components/user-autocomplete';
import * as imageUploader from './lib/textarea-image-uploader';

import {Socket} from 'phoenix';
import LiveSocket from 'phoenix_live_view';
let Hooks = {};
Hooks.SyntaxHighlight = {
  mounted() {
    syntaxHighlighting.highlightSyntax(`#${this.el.id}`);
  },
};
Hooks.ImageUploader = {
  mounted() {
    imageUploader.setupImageUploader(`#${this.el.id}`);
  },
};
Hooks.CommentPreview = {
  mounted() {
    commentForm.setupNewForm();
  },
  updated() {
    commentForm.setupNewForm();
  },
};
let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute('content');
let liveSocket = new LiveSocket('/live', Socket, {hooks: Hooks, params: {_csrf_token: csrfToken}});
liveSocket.connect();
window.liveSocket = liveSocket;

// Make the modules available to html pages
global.constable = global.constable || {
  commentForm,
  syntaxHighlighting,
  announcementForm,
  announcementFormMobile,
  textareaImageUploader,
  userAutocomplete,
};
