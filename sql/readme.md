# Setting up your development environment

1. `cp config/database.yml.skel config/database.yml`
2. Update passwords to `'data'` in `config/database.yml`
3. `cp config/initializers/devise.rb.example config/initializers/devise.rb`
4. `touch config/initializers/secret_token.rb`
5. Add `TheCourseForum::Application.config.secret_key_base = "othersecretkey1234"` in `config/initializers/secret_token.rb`
6. `cp config/application.yml.example config/application.yml`
7. Login to http://phpmyadmin.thecourseforum.com/ (ask for username & password)
8. Once you're logged in, expand `thecourseforum` tab on the left
9. Export the `thecourseforum_development` and `thecourseforum_production` databases
10. Place these `.sql` files within this `./sql/` directory
11. `docker-compose up` This might take a few minutes...
12. The server will be listening on `localhost:3000` (Note: if you are using docker toolkit, you might have 
	get the ip address of the docker vm using 'docker-machine ip' and replacing localhost with that address)
13. Once it finishes, you are ready to develop! :) 