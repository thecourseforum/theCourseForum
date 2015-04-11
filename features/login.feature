Feature: Login to tCF homepage
	In order to use theCourseForum
	As a registered user I want to login

	Background:
		Given the link 'http://localhost:3000'
		Then I should see Email and Password text fields

	@javascript
	Scenario: page should be found

	@javascript
	Scenario: should not login ui without parameters
		When I login ui without parameters
		Then I should see notice: 'Invalid email or password'

	@javascript
	Scenario: should not login ui with wrong password
		When I login ui with 'aw3as@virginia.edu' 'passwerd'
		Then I should see notice: 'Invalid email or password'

	@javascript
	Scenario: should login ui with good name and right password
		When I login ui with 'aw3as@virginia.edu' 'password'
		Then I should see notice: 'Signed in successfully'

		When I logout
		Then I should see notice: 'Signed out successfully'
		And I should see Email and Password text fields