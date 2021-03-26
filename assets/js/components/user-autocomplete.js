import { Textcomplete, Textarea } from 'textcomplete';

const AT_REGEX = /(^|\s)@(\w*)$/;

export const autocompleteUsers = (selector, users) => {
  const usernameStrategy = {
    id: 'username',
    match: AT_REGEX,
    search: (term, callback) => {
      term = term.toLowerCase();

      if (term === '') {
        callback(users);
      } else {
        const matches = users.filter((user) => {
          const name = user.name;
          const username = user.username;
          const matchesName = name.toLowerCase().startsWith(term);
          const matchesUsername = username.toLowerCase().startsWith(term);

          return matchesName || matchesUsername;
        });
        callback(matches);
      }
    },

    template(user, _term) {
      return `<img class="tbds-avatar tbds-avatar--circle tbds-avatar--small tbds-margin-inline-end-2" alt="${user.name}" src="${user.profile_image_url}" height="80" width="80"/> ${user.username}`;
    },

    replace(user) {
      return `$1@${user.username} `;
    },
  };

  const editor = new Textarea(document.querySelector(selector));
  const textcomplete = new Textcomplete(editor);
  textcomplete.register([ usernameStrategy ]);
};
