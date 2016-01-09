@javascript
Feature: Go to about page
	As a main feature on theCourseForum
	I want to be see the about page

	Background:
		Given a user is logged in

	Scenario: should be able to navigate to the about page
		When I click the link 'ABOUT'
		Then I should see 'connecting you to the courses you love'