@javascript
Feature: Search for a course
	In order to browse courses on theCourseForum
	I want to be able to search for a course

	Background:
		Given a user is logged in
		Given courses exist

	Scenario: should be able to search for a course
		When I search for 'CS 2150'
		Then I should see 'CS 2150 - Search Results'
		And I should see 'Aaron Bloomfield'

	Scenario: result should link to course
		When I search for 'CS 2150'
		And I click on 'Aaron Bloomfield'
		Then I should see 'CS 2150 - Program and Data Representation'
		And I should see 'Write Your Own Review!'