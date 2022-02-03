FROM ruby:2.7.5

LABEL org.opencontainers.image.source="https://github.com/codeandomexico/decidim-monterrey"

ARG RAILS_ENV
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
RUN bundle check || bundle install --jobs=4
RUN yarn install
RUN bundle exec rails assets:precompile
COPY . .

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
