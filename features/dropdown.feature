@javascript
Feature: Dropdown professor switching
	In order to switch professors on the review page
	I want to be able to use the dropdown to switch

	Background:
		Given the course show page of ECON 2010
		Given a course
		Given the professors

	Scenario: professors should be found
		Then I should see a list of professors

	Scenario: professors should be sorted by keystroke
		When I type the letter 'e'
		Then I should see a list of 'e' professors

	Scenario: should load new professor page
		When I click on "Elzinga, Kenneth"
		Then I should see "Elzinga, Kenneth"

	Scenario: should load new professor page on enter when there's only one professor
		When I type "elz"
		When I hit enter
		Then I should see "Ezlinga, Kenneth"

