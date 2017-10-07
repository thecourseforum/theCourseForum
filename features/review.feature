@javascript
Feature: Write a tCF Review
	As a main feature on theCourseForum
	I want to be able to write a review

	Background:
		Given a user is logged in
		And I click the sidebar link 'Review'

	Scenario: should be able to navigate to write a review
		Then I should see 'What class are you reviewing?'

	Scenario: should be able to write a review
		When I write a review
		And I should see notice: 'Review was successfully created.'
		Then I should see title 'My Reviews'
		And I should see 'Test Review'

	Scenario: should not be able to write a second review
		When I write a review
		And I click the link 'Review'
		And I write a review
		Then I should see notice: 'You have already written a review for this class.'		
		And I should see 'My Reviews'