# Constable

**Constable is part of the [thoughtbot Elixir family][elixir-phoenix] of projects.**

Constable is a Phoenix app for posting announcements and having discussions.
To learn more about Phoenix, check out [Programming Phoenix](https://pragprog.com/book/phoenix/programming-phoenix)

## Starting the Console

Use `bin/console` to start the console. Use `bin/console staging|production` to
start the console in staging or production.

## Reactivating Users

Users are deactivated if they leave thoughtbot. Sometimes someone with the same
first name joins thoughtbot later and inherits the deactivated email so we need
to reactivate the email.

* Run `bin/console production`
* Run `Constable.User.reactivate("person@thoughtbot.com")`

## Developing the Application

To set up your development environment, there are a few steps you'll need to
follow.

### Install Required Dependencies

If you're on OS X and using Homebrew, run `brew install elixir phantomjs node`.
Otherwise, follow the instructions on the [Elixir installation page], the
[PhantomJS page], and the [Node downloads page].

[Elixir installation page]: http://elixir-lang.org/install.html
[PhantomJS page]: http://phantomjs.org/download.html
[node downloads page]: https://nodejs.org/en/download/

### Configure Your Local Environment

Run:

  ```sh
  # Will grab all Elixir and NPM dependencies and then setup the database
  $ bin/setup
  ```

### Starting the Phoenix Server

Once all the dependencies have been installed, you can start the Phoenix
server with:

  ```sh
  $ mix phoenix.server
  ```

## Email Templates

You can edit the email contents from `web/templates/email`.

You can preview templates by going to `localhost:4000/emails/#{template_name}`.
You can find a list of templates in the `EmailPreviewController`.

## Viewing Sent Emails

You can view sent emails in development by going to `localhost:4000/sent_emails`

## Testing

1. Run `bin/test_suite` for testing the whole test suite. The script will build
   assets that are needed for testing js acceptance tests, or
2. Run `mix test` for individual tests

## Static Analysis

Run `mix dialyzer.plt` to build the lookup table for static analysis. Then run
`mix dialyzer` to run analysis. If your dependencies or your elixir version
change, delete `.dialyzer.plt` and run `mix dialyzer.plt` to rebuild it.

There are still a lot of warnings that are not fixable, but occasionally some
real errors are found by dialyzer

## Deployment

1. If you have not run `bin/setup` yet, run it to add the correct git remotes.
2. Run `bin/deploy (staging|production)`

## Review Apps

Constable is setup with support for [Heroku Review Apps].

Google enforces a white list of OAuth redirect URLs, so for review apps we
redirect the OAuth flow through the [Constable oauth redirector] which then
redirects back to the correct review app. This is configured with the
`OAUTH_REDIRECT_OVERRIDE` environment variable.

[Heroku Review Apps]: https://devcenter.heroku.com/articles/github-integration-review-apps
[Constable oauth redirector]: https://github.com/thoughtbot/constable-oauth-redirector

## License

Constable is Copyright (c) 2015-2016 Blake Williams, Paul Smith, and thoughtbot,
inc. It is free software, and may be redistributed under the AGPL license
detailed in the [LICENSE] file.

[LICENSE]: /LICENSE

## About thoughtbot

![thoughtbot](http://presskit.thoughtbot.com/images/thoughtbot-logo-for-readmes.svg)

Constable is maintained and funded by thoughtbot, inc.
The names and logos for thoughtbot are trademarks of thoughtbot, inc.

We love open source software, Elixir, and Phoenix. [Work with thoughtbot's
Elixir development team][elixir-phoenix] to design, develop, and grow your
product.

[elixir-phoenix]: https://thoughtbot.com/services/elixir-phoenix?utm_source=github
