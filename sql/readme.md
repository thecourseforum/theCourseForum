# Setting up your development environment

-  `cp config/database.yml.skel config/database.yml`
-  Update 'password' field to `data` in `config/database.yml` for all the databases
-  Comment out the 'socket' fields, and add a 'host' field for all the databases
-  Set 'host' fields to `db` 
-  `cp config/initializers/devise.rb.example config/initializers/devise.rb`
-  `touch config/initializers/secret_token.rb`
-  Add `TheCourseForum::Application.config.secret_key_base = "othersecretkey1234"` in `config/initializers/secret_token.rb`
-  `cp config/application.yml.example config/application.yml`
-  Login to http://phpmyadmin.thecourseforum.com/ (ask for username & password)
-  Once you're logged in, expand `thecourseforum` tab on the left
-  Export the `thecourseforum_development` and `thecourseforum_production` databases
-  Place these `.sql` files within this `./sql/initialize` directory
-  If you want to use the copy of the production database, run `cp sql/initialize/thecourseforum_production.sql 		sql/initialize/thecourseforum_development.sql`
-  `docker-compose up` This might take a few minutes...
-  The server will be listening on `localhost:3000` (Note: if you are using docker toolkit, you might have 
	get the ip address of the docker vm using 'docker-machine ip' and replacing localhost with that address)
-  Once it finishes, you are ready to develop! :) 

# Running your development environment after setup
`docker-compose up` It's that easy :-)