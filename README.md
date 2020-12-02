# Constable

**Constable is part of the [thoughtbot Elixir family][elixir-phoenix] of projects.**

Constable is a Phoenix app for posting announcements and having discussions.
To learn more about Phoenix, check out [Programming Phoenix](https://pragprog.com/titles/phoenix14/programming-phoenix-1-4/)

## Starting the Console

Use `bin/console` to start the console. Use `bin/console staging|production` to
start the console in staging or production.

## Reactivating Users

Users are deactivated if they leave thoughtbot. Sometimes someone with the same
first name joins thoughtbot later and inherits the deactivated email so we need
to reactivate the email. There are two ways to reactivate a user: 

1. From the browser: 
  * Visit `/user_activations`
  * Click on Activate the user

2. From the console:
  * Run `bin/console production`
  * Run `Constable.User.reactivate("person@thoughtbot.com")`

## Developing the Application

To set up your development environment, there are a few steps you'll need to
follow.

### Install Required Dependencies

You need to have Erlang, Elixir, Node and ChromeDriver installed. This section
describes the easiest way to do that.

If you're on OS X and using Homebrew, run `brew install node` to get nodejs.

Once node is installed, run `npm -g install chromedriver`.

Finally, install the [asdf] package manager, which will read the
`.tool-versions` file from the repo to install the correct versions of Erlang
and Elixir. Downloading and installing Erlang might take a while, so be patient
on first run. You should be able to run `asdf install` from the project directly
to install the required packages.

[asdf]: https://github.com/asdf-vm/asdf

### Configure Your Local Environment

Run:

  ```sh
  # Will grab all Elixir and NPM dependencies and then setup the database
  $ bin/setup
  ```

### Set up local data and env vars for Google OAuth

You'll want to have certain environment variables and user data set up so you
can log into the app locally with your thoughtbot email.

In `.env`, there are three values that say "get-from-staging" - CLIENT_ID,
CLIENT_SECRET, and HUB_API_TOKEN. Replace these values with the ones from
staging. Find them by running `heroku config -r staging`.

You'll also want to grab the STAGING_DB_ENV_VAR from staging. Run:
`heroku pg:pull STAGING_DB_ENV_VAR constable_api_development -r staging`,
where the value of STAGING_DB_ENV_VAR is what you got from the heroku config.
This will copy the data over so you have example data to work with, including
your already existing user account.

### Starting the Phoenix Server

Once all the dependencies have been installed, you can start the Phoenix
server with:

  ```sh
  $ mix phx.server
  ```

## Email Templates

You can edit the email contents from `web/templates/email`.

You can preview templates by going to `localhost:4000/emails/#{template_name}`.
You can find a list of templates in the `EmailPreviewController`.

## Viewing Sent Emails

You can view sent emails in development by going to `localhost:4000/sent_emails`

## Testing

Run `mix test`

## Static Analysis

Run `mix dialyzer` to run the analysis. The lookup table will be created by this
process. If your dependencies or your elixir version change, delete
`.dialyzer.plt` and run `mix dialyzer.plt` to rebuild it.

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
