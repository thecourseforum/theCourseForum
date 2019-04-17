FROM ruby:2.2.3

# install packages here, in the future
# RUN apt-get update

# install bundler
RUN gem install bundler -v 1.12.5

## Install gems
RUN mkdir /tcf
WORKDIR /tcf
# cache gemfiles to shorten builds
COPY Gemfile /tcf/Gemfile
COPY Gemfile.lock /tcf/Gemfile.lock
RUN bundle install
COPY . /tcf

## Rails app will listen on this port
EXPOSE 3000

CMD ["rails", "s"]