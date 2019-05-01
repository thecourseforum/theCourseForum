echo "Precompiling..."
bundle exec rake assets:precompile db:migrate RAILS_ENV=production
chown -R app:app /home/app/theCourseForum