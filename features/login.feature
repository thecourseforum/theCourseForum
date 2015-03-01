Feature: Login to tCF homepage
	In order to use theCourseForum
	As a registered user I want to login

	@javascript
	Scenario: page should be found
		Given the link 'http://localhost:3000'
		Then I should see 'Email' and 'Password' text fields

	@javascript
	Scenario: should not login ui without parameters
		Given the link 'http://localhost:3000'
		When I login ui without parameters
		Then I should see notice: 'Invalid email or password'

	@javascript
	Scenario: should not login ui with wrong password
		Given the link 'http://localhost:3000'
		And credentials 'mst3k@virginia.edu' 'foobarbez'
		When I login ui
		Then I should see notice: 'Invalid email or password'

	@javascript
	Scenario: should login ui with good name and right password and correct cluster
		Given the link 'http://localhost:3000'
		And credentials 'mst3k@virginia.edu' 'foobarbaz'
		When I login ui
		Then I should see notice: 'Signed in successfully'

		Then I logout
		And I should see 'Email' and 'Password' text fields