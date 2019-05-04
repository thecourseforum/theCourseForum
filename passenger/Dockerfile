FROM phusion/passenger-customizable

# Set correct environment variables.
ENV HOME /root

# Use baseimage-docker's init process.
CMD ["/sbin/my_init"]

# use ruby 2.2.3
RUN bash -lc 'rvm install ruby-2.2.3'
RUN bash -lc 'rvm --default use ruby-2.2.3'

# Install Certbot and wget
RUN apt-get update
RUN apt-get install software-properties-common -y
RUN add-apt-repository universe
RUN add-apt-repository ppa:certbot/certbot
RUN apt-get update
RUN apt-get install certbot python-certbot-nginx -y

# Install Firefox for headless browser testing
# TODO: separate testing container?
# RUN apt-get install wget xvfb -y
# RUN wget https://github.com/mozilla/geckodriver/releases/download/v0.24.0/geckodriver-v0.24.0-linux64.tar.gz
# RUN tar -xf geckodriver-v0.24.0-linux64.tar.gz
# RUN rm geckodriver-v0.24.0-linux64.tar.gz
# RUN mv geckodriver /bin

# Install Node and Yarn
RUN curl -sL https://deb.nodesource.com/setup_11.x | /bin/bash -
RUN apt-get update
RUN apt install nodejs libmysqlclient-dev -y
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install yarn -y

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

# Run bundle install as 'app' user
RUN setuser app bundle install

## copy over app
COPY --chown=app:app . /home/app/theCourseForum

RUN yarn install

# enable Nginx and Passenger
RUN rm -f /etc/service/nginx/down

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*