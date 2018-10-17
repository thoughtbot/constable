import css from '../css/app.scss'

// Framework JS
import 'phoenix_html'

// Bring in jQuery for other modules that rely on it
import $ from 'jquery'
window.jQuery = $
window.$ = $

// Set up turbolinks
import TurboLinks from 'turbolinks'
TurboLinks.start()

// Set up local-time
import LocalTime from 'local-time'
LocalTime.start()

// Make the modules available to html pages
global.constable = global.constable || {}
global.constable.settingsFormModal = require('./settings-form-modal')
global.constable.commentForm = require('./comment-form')
global.constable.syntaxHighlighting = require('./syntax-highlighting')
global.constable.announcementForm = require('./announcement-form')
global.constable.announcementFormMobile = require('./announcement-form-mobile')
global.constable.textareaImageUploader = require('./textarea-image-uploader')
global.constable.userAutocomplete = require('./user-autocomplete')


import { Application } from "stimulus"
import { definitionsFromContext } from "stimulus/webpack-helpers"

const application = Application.start()
const context = require.context("./controllers", true, /\.js$/)
application.load(definitionsFromContext(context))
