FROM thoughtbot/elixir
MAINTAINER Joe Ferris <jferris@thoughtbot.com>
ENV DEBIAN_FRONTEND noninteractive
ENV LANG en_US.UTF-8

RUN apt-get update && apt-get install -y --no-install-recommends \
      postgresql-client

RUN mkdir /app
WORKDIR /app
ADD mix.* /app/
RUN mix local.rebar --force
RUN mix local.hex --force
RUN mix deps.get
ADD . /app/
RUN mix compile
