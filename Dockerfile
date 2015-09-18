FROM elixir
MAINTAINER Joe Ferris <jferris@thoughtbot.com>
ENV DEBIAN_FRONTEND noninteractive
ENV LANG en_US.UTF-8

RUN apt-get update && apt-get install -y --no-install-recommends \
      postgresql-client

RUN mkdir /app
RUN mkdir /deps
WORKDIR /app
COPY mix.* /app/
RUN mix local.hex --force
RUN mix deps.get
RUN yes | mix deps.compile
COPY . /app/
RUN mix compile
