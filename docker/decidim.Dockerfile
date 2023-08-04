FROM ruby:2.7.5

LABEL org.opencontainers.image.source="https://github.com/codeandomexico/decidim-monterrey"

ARG FORCE_SSL
ARG RAILS_ENV
ARG MAILER_SENDER
ARG SECRET_KEY_BASE
ENV SHELL /bin/bash

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y git imagemagick wget
RUN apt-get clean
RUN curl -sL https://deb.nodesource.com/setup_16.x | bash -
RUN apt-get install -y nodejs
RUN apt-get clean
RUN npm install -g yarn
RUN gem install bundler

WORKDIR /decidim
COPY Gemfile .
COPY Gemfile.lock .
COPY decidim-module-ine/decidim-ine.gemspec ./decidim-module-ine/
COPY decidim-module-ine/lib/decidim/ine/version.rb ./decidim-module-ine/lib/decidim/ine/
COPY omniauth-idmty/omniauth-idmty.gemspec ./omniauth-idmty/
COPY omniauth-idmty/lib/omniauth/omniauth-idmty/version.rb ./omniauth-idmty/lib/omniauth/omniauth-idmty/
RUN bundle check || bundle install --jobs=4
COPY . .
RUN yarn install
RUN bundle exec rails webpacker:compile
RUN chmod +x /decidim/docker/entrypoints/decidim.sh
