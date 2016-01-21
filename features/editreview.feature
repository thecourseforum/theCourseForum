@javascript
Feature: Edit a tCF Review
	As a main feature on theCourseForum
	I want to be able to edit a review

	Background:
		Given a user is logged in
		And a review exists
		When I click the link 'Alan'
		And I click the link 'My Reviews'

	Scenario: should be able to see my reviews
		Then I should see 'Aaron Bloomfield'
		Then I should see 'Edit Review'

	Scenario: should be able to navigate to edit a review
		When I click the link 'Edit Review'
		Then I should see 'Editing review'
		Then I should see 'Sample Text Here'

	Scenario: should be able to edit a review
		When I click the link 'Edit Review'
		When I edit a review
		And I should see notice: 'Review was successfully updated.'
		When I click the link 'Edit Review'
		And I should see 'NEW TEXT'