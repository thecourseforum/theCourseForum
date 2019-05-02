#!/bin/sh
echo "Precompiling..."
runuser -l app -c 'bundle exec rake assets:precompile db:migrate RAILS_ENV=production'