@javascript
Feature: Edit a tCF Review
	As a main feature on theCourseForum
	I want to be able to edit a review

	Background:
		Given a user is logged in
		And I click the link 'My Name'
		And I click the link 'My Reviews'

	Scenario: should be able to navigate to edit a review
		When I click the link 'Edit Review'
		Then I should see 'Editing review'

	Scenario: should be able to edit a review
		When I edit a review
		Then I should see 'Comments'
		And I should see 'What class are you reviewing?'
		And I should see notice: 'Review was successfully edited.'
		And I should see edited review