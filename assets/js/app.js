import '../css/app.scss'

// Framework JS
import 'phoenix_html'

import { Application } from 'stimulus'
import { definitionsFromContext } from 'stimulus/webpack-helpers'

import TurboLinks from 'turbolinks'
import LocalTime from 'local-time'

TurboLinks.start()
LocalTime.start()

// Set up live comment updating
require('./live-comments')

const application = Application.start()
const context = require.context('./controllers', true, /\.js$/)
application.load(definitionsFromContext(context))
