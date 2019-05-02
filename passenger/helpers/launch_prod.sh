#!/bin/bash

docker-compose -f docker-compose.yml -f docker-compose.prod.yml up --build -d

docker-compose exec tcf bundle exec rake assets:precompile db:migrate RAILS_ENV=production

docker-compose restart tcf