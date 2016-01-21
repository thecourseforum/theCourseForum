@javascript
Feature: Write a tCF Review
	As a main feature on theCourseForum
	I want to be able to write a review

	Background:
		Given a user is logged in
		Given courses exist
		And I click the link 'Write a review'

	Scenario: should be able to navigate to write a review
		Then I should see 'What class are you reviewing?'

	Scenario: should be able to write a review
		When I write a review
		And I should see notice: 'Review was successfully created.'
		And I click the link 'Aaron Bloomfield'
		Then I should see 'Comment'
		And I should see 'Test Review'

	Scenario: should not be able to write a second review
		When I write a review
		And I click the link 'Write a review'
		And I write a review
		Then I should see notice: 'You have already written a review for this class.'		
		And I should see 'My Reviews'