# Constable API

Constable API uses Phoenix Channels to make a real time connection to the
Constable front end.

Use `bin/console` to start the console. Use `bin/console staging|production` to
start the console in staging or production.

## Developing the Application

To set up your development environment, there are a few steps you'll need to
follow.

### Install Elixir and Phantomjs

If you're on OS X and using Homebrew, run `brew install elixir` and `brew
install phantomjs`. Otherwise, follow the instructions on the [Elixir
installation page] and the [Phantomjs page].

[Elixir installation page]: http://elixir-lang.org/install.html
[Phantomjs page]: http://phantomjs.org/download.html

### Configure Your Local Environment

1. Run:

  ```sh
  # Will grab all Elixir and NPM dependencies and then setup the database
  bin/setup
  ```

2. Get necessary env variables:

  Go to [`constable-api-staging`], click "Reveal Config Vars" and copy/paste the
  `CLIENT_ID` and `CLIENT_SECRET` into your `.env` file.

[`constable-api-staging`]: https://dashboard-preview.heroku.com/apps/constable-api-staging/settings

### Starting the Phoenix Server

Once all the dependencies have been installed, you can start the Phoenix
server with:

```sh
mix phoenix.server
```

## Email Templates

You can edit the email contents from `web/templates/email`.

You can preview templates by going to `localhost:4000/emails/#{template_name}`.
You can find a list of templates in the `EmailPreviewController`.

## Viewing Sent Emails

You can view sent emails in development by going to `localhost:4000/sent_emails`

## Testing

1. Run `mix test`

## Static Analysis

Run `mix dialyzer.plt` to build the lookup table for static analysis. Then run
`mix dialyzer` to run analysis. If your dependencies or your elixir version
change, delete `.dialyzer.plt` and run `mix dialyzer.plt` to rebuild it.

There are still a lot of warnings that are not fixable, but occasionally some
real errors are found by dialyzer

## Using the Constable API

Visit the [thoughtbot/constable repo](http://github.com/thoughtbot/constable) to
see how to use the API.
The [app/stores](https://github.com/thoughtbot/constable/tree/master/app/stores)
folder has a few the best examples.

## Deployment

1. If you have not run `bin/setup` yet, run it to add the correct git remotes.
2. Run `bin/deploy (staging|production)`
