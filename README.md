# Constable API

Constable API uses Phoenix Channels to make a real time connection to the
Constable front end.

Use `bin/console` to start the console. Use `bin/console staging|production` to
start the console in staging or production.

## Starting Constable

1. Install elixir. If you're on OS X, run `brew install elixir`
2. Run `bin/setup` to install dependencies and setup the database.
3. Start Phoenix endpoint with `mix phoenix.server`

## Email templates

You can edit the email contents from `web/templates/email`.

You can preview templates by going to `localhost:4000/emails/#{template_name}`.
You can find a list of templates in the `EmailPreviewController`.

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
