@javascript
Feature: Dropdown professor switching
	In order to switch professors on the review page
	I want to be able to use the dropdown to switch

	Background:
		Given a user is logged in
		And courses exist
		And I click the link 'Browse All'
		And I click the link 'Computer Science'
		And I click the link 'CS 2150'
		And I click the link 'Aaron Bloomfield'

	Scenario: professors should be found
		Then I should see 'Bloomfield, Aaron'

	Scenario: professors should be listed
		When I click on the dropdown
		Then I should see 'All Professors'
		Then I should see 'Floryan, Mark'
		Then I should see 'Bloomfield, Aaron'

	Scenario: should load new professor page
		When I click on the dropdown
		When I click the link 'Floryan, Mark'
		Then I should see 'Floryan, Mark'
