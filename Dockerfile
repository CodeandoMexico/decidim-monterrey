FROM ruby:2.7.5

LABEL maintainer="oscar@codeandomexico.org"

ENV RAILS_ENV production
ENV RAILS_SERVE_STATIC_FILES=true
ENV BUNDLE_WITHOUT=development:test
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
COPY . .

RUN yarn install
RUN bundle check || bundle install
RUN bundle exec rake assets:precompile

ENTRYPOINT []
CMD ["bundle", "exec", "rails", "s", "-b", "0.0.0.0"]
