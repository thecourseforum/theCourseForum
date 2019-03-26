FROM ubuntu:latest

RUN apt-get update

## Default Packages
RUN apt-get install -y build-essential 
RUN apt-get install -y wget curl git git-core apt-transport-https libmysqlclient-dev

## RVM
RUN \curl -sSL https://get.rvm.io | bash
## Set path
ENV PATH /usr/local/rvm/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# setup rvm & ruby version
RUN /bin/bash -l -c "rvm requirements"
RUN /bin/bash -l -c "rvm install 2.2.3"
RUN /bin/bash -l -c "rvm use 2.2.3"
RUN /bin/bash -l -c "gem install bundler -v 1.12.5"

## Install gems
RUN mkdir /tcf
COPY . /tcf
WORKDIR /tcf
RUN /bin/bash -l -c "bundle install"

## Setup mysql database
RUN /bin/bash -l -c "debconf-set-selections <<< 'mysql-server mysql-server/root_password password data'"
RUN /bin/bash -l -c "debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password data'"
RUN apt-get -y install mysql-server
RUN chmod 777 calibrate_db.sh
RUN sed -i -e 's/\r$//' calibrate_db.sh

## Rails app will listen on this port
EXPOSE 3000

CMD ["rails", "s"]