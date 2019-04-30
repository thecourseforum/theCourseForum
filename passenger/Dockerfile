FROM phusion/passenger-customizable


# Set correct environment variables.
ENV HOME /root

# Use baseimage-docker's init process.
CMD ["/sbin/my_init"]

# use ruby 2.2.3
RUN bash -lc 'rvm install ruby-2.2.3'
RUN bash -lc 'rvm --default use ruby-2.2.3'

# Install Certbot
RUN apt-get update
RUN apt-get install software-properties-common
RUN add-apt-repository universe
RUN add-apt-repository ppa:certbot/certbot
RUN apt-get update
RUN apt-get install certbot python-certbot-nginx -y


# Install Node and Yarn
RUN curl -sL https://deb.nodesource.com/setup_11.x | /bin/bash -
RUN apt-get update
RUN apt install nodejs libmysqlclient-dev -y
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install yarn -y

# ...put your own build instructions here...

# copy over startup scripts
RUN mkdir -p /etc/my_init.d
ADD ./passenger/passenger_init.sh /etc/my_init.d/passenger_init.sh

# copy over nginx configs
RUN rm /etc/nginx/sites-enabled/default
RUN ls /etc/nginx/conf.d
# RUN cp /etc/nginx/conf.d /etc/nginx/sites-enabled/thecourseforum.conf

# make app dir
RUN mkdir /home/app/theCourseForum
RUN chown -R app:app /home/app/theCourseForum

## compile rails and install deps
WORKDIR /home/app/theCourseForum
# cache gemfiles to shorten builds
COPY --chown=app:app Gemfile /home/app/theCourseForum/Gemfile
COPY --chown=app:app Gemfile.lock /home/app/theCourseForum/Gemfile.lock
# USER app
# WORKDIR /home/app/theCourseForum
# RUN bundle install --deployment --without development test
RUN bundle install
# USER root

## copy over app
COPY --chown=app:app . /home/app/theCourseForum

RUN yarn install

# enable Nginx and Passenger
RUN rm -f /etc/service/nginx/down

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*