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
