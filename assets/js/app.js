import css from '../css/app.scss';

// Framework JS
import 'phoenix_html';

// Basic AJAX Helper
import './remote-append';

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

//LiveView
import {Socket} from "phoenix"
import LiveSocket from "phoenix_live_view"

// Make the modules available to html pages
global.constable = global.constable || {};
global.constable.commentForm = require('./comment-form');
global.constable.syntaxHighlighting = require('./syntax-highlighting');
global.constable.announcementForm = require('./announcement-form');
global.constable.announcementFormMobile = require('./announcement-form-mobile');
global.constable.textareaImageUploader = require('./textarea-image-uploader');
global.constable.userAutocomplete = require('./user-autocomplete');

// Set up LiveView
let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {params: {_csrf_token: csrfToken}})

// Connect if there are any LiveViews on the page
liveSocket.connect()

// Expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)
// The latency simulator is enabled for the duration of the browser session.
// Call disableLatencySim() to disable:
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket
