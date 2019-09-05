# Contributing

By participating in this project, you agree to abide by the thoughtbot [code of
conduct].

We expect everyone to follow the code of conduct anywhere in thoughtbot's
project codebases, issue trackers, chatrooms, and mailing lists.

[code of conduct]: https://thoughtbot.com/open-source-code-of-conduct

## Contributing Code

Constable is a messaging application in active use at thoughtbot. We welcome
pull requests, but ask you to **please open an issue to discuss any proposed new
features** you would like merged upstream.

To contribute code to the application:

1. Fork and clone the repo.
2. Install dependencies and setup the project by running `bin/setup`.
3. Make sure the tests pass by running `mix test`.
4. Make your change with new passing tests. Follow the [style guide][style].
5. Push to your fork. Write a [good commit message][commit].
6. Submit a pull request.

Others will give constructive feedback. This is a time for discussion and
improvements, and making the necessary changes will be required before we can
merge the contribution.

  [style]: https://github.com/thoughtbot/guides/tree/master/style
  [commit]: http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html

## CSS

- Organize and architect CSS using the [Inverted Triangle CSS (ITCSS)][itcss]
  methodology
- Lint styles using stylelint
  - The stylelint configuration is in
    [`assets/.stylelintrc.json`][stylelint-config]

[itcss]: https://www.creativebloq.com/web-design/manage-large-css-projects-itcss-101517528
[stylelint-config]: /assets/.stylelintrc.json

## JavaScript

- ES6 JavaScript (no transpilation)
 - Lint Javascript using eslint
  - The ESLint configuration is in [`assets/.eslintrc.json`][eslint-config]

[eslint-config]: /assets/.eslintrc.json
