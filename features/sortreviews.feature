@javascript
Feature: Sort reviews 
	As a main feature on theCourseForum
	I want to be able to sort reviews by rating

	Background:
		Given a user is logged in
		And courses exist
		And reviews exist
		And I click on 'Browse All'
		And I click on 'Computer Science'
		And I click on 'CS 2150'
		And I click on 'Bloomfield'

	Scenario: Sorting reviews by most recent
		When I toggle dropdown to 'Most Recent'
		Then I should see 'Recent Review' first
		Then I should see 'Older Review' second

	Scenario: Sorting reviews by most helpful
		When I toggle dropdown to 'Most Helpful'
		Then I should see 'Helpful Review' first		

	Scenario: Sorting reviews by semester
		When I toggle dropdown to 'Semester'
		Then I should see 'Review for this semester' first
		
	Scenario: Sorting reviews by highest rating
		When I toggle dropdown to 'Highest Rating'
		Then I should see 'Review with high rating' first
		Then I should see 'Review with low rating' last
		
	Scenario: Sorting reviews by lowest rating
		When I toggle dropdown to 'Lowest Rating'
		Then I should see 'Recent Review' first
		Then I should see 'Older Review' second