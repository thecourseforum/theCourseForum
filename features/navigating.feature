@javascript
Feature: Navigate the site
	In order to browse pages on theCourseForum
	I want to be able to search for professors

	Background:
		Given a user is logged in
		Given courses exist

	Scenario: should be able to go from the browse all page to a specific course professor
		Given the browse all page
		Then I should see 'Computer Science'
		Then I should see 'CS 2150'
		Then I should see 'Aaron Bloomfield'

	Scenario: should be able to toggle between current semester and all semesters
		Given the 'Special Topics in Computer Science' page
		Then I should not see David Evans
		And I click on 'All'
		Then I should see David Evans