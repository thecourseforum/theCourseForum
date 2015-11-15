@javascript
Feature: Upvote a Review
	As a feature of the class show page
	I want to be able to upvote a review

	Background:
		Given a user is logged in
		Given courses exist
		Given professors exist
		And I navigate to a course show page of CS 1110 with Mark Sherriff

	Scenario: upvote a review the user hasn't voted on
		When I upvote the first review
		Then I should see the votes incremented

	Scenario: downvote a review the user hasn't voted on
		When I upvote the first review
		Then I should see the votes decremented

	Scenario: should have same votes on reload unless the vote was the users
		When I reload the page
		Then the votes on the review should show the update

