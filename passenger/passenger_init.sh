#!/bin/sh
echo "Precompiling..."
bundle exec rake assets:precompile db:migrate RAILS_ENV=production