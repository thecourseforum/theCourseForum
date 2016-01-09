@javascript
Feature: Search for a course
	In order to browse courses on theCourseForum
	I want to be able to search for a course

	Background:
		Given a user is logged in
		Given courses exist

	Scenario: should be able to search for a course
		When I search for 'CS 2150'
		Then I should see 'Search Results'
		And I should see 'Program and Data Representation'

	Scenario: result should link to course
		When I search for 'CS 2150'
		And I click on Program and Data Representation
		Then I should see 'Aaron Bloomfield'
		Then I should see 'Mark Floryan'