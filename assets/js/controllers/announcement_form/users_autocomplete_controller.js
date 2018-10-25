import { Controller } from 'stimulus'
import { Textcomplete, Textarea } from 'textcomplete'

const AT_REGEX = /(^|\s)@(\w*)$/

export default class extends Controller {
  initialize() {
    const users = this._userdata()

    const usernameStrategy = {
      id: 'username',
      match: AT_REGEX,
      search: (term, callback) => {
        term = term.toLowerCase()

        if (term === '') {
          callback(users)
        } else {
          const matches = users.filter((user) => {
            const name = user.name
            const username = user.username
            const matchesName = name.toLowerCase().startsWith(term)
            const matchesUsername = username.toLowerCase().startsWith(term)

            return matchesName || matchesUsername
          })
          callback(matches)
        }
      },

      template: function(user, _term) {
        return `<img class="avatar-rounded" src="${user.gravatar_url}"/> ${user.username}`
      },

      replace: function(user) {
        return `$1@${user.username} `
      }
    }

    const editor = new Textarea(this.element)
    const textcomplete = new Textcomplete(editor)
    textcomplete.register([usernameStrategy])
  }

  _userdata() {
    const element = document.getElementById('users_for_autocomplete')
    return JSON.parse(element.dataset.users)
  }
}
