FROM ruby:2.2.3

## Install node and yarn
# update sources for debian jessie
RUN printf "deb http://archive.debian.org/debian/ jessie main\ndeb-src http://archive.debian.org/debian/ jessie main\ndeb http://security.debian.org jessie/updates main\ndeb-src http://security.debian.org jessie/updates main" > /etc/apt/sources.list
RUN apt-get update
RUN curl -sL https://deb.nodesource.com/setup_11.x | /bin/bash -
RUN apt install nodejs -y
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install yarn -y

## Install bundler
RUN gem install bundler -v 1.12.5

## Install gems
RUN mkdir /tcf
WORKDIR /tcf
# cache gemfiles to shorten builds
COPY Gemfile /tcf/Gemfile
COPY Gemfile.lock /tcf/Gemfile.lock
RUN bundle install
# attempt to cache node modules also
# COPY package.json /tcf/package.json
# COPY yarn.lock /tcf/yarn.lock
# RUN yarn install
# copy over project
COPY . /tcf

## Rails app will listen on this port
EXPOSE 3000

CMD ["rails", "s"]