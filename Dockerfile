FROM ruby:2.2.2
RUN apt-get update && apt-get install -y nodejs libpq-dev --no-install-recommends && rm -rf /var/lib/apt/lists/*

RUN mkdir /app

COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
WORKDIR /app
RUN bundle install
ADD . /app

ENV RAILS_ENV production

RUN bundle exec rake assets:precompile --trace
