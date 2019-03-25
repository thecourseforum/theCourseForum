FROM ruby:2.2.3

RUN apt-get update
RUN apt-get install -y git-core curl build-essential nodejs

RUN mkdir /tcf
COPY . /tcf
WORKDIR /tcf
RUN gem install bundler -v 1.12.5
RUN bundle install

RUN /bin/bash -l -c "debconf-set-selections <<< 'mysql-server mysql-server/root_password password data'"
RUN /bin/bash -l -c "debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password data'"
RUN apt-get -y install mysql-server
RUN chmod 777 calibrate_db.sh
RUN ./calibrate_db.sh

EXPOSE 3000

CMD ["rails", "s"]