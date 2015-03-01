Feature: Contact tCF
	In order express a comment/issue/concern theCourseForum
	As a registered user I want to contact tcF

	Scenario: page should be found
		Given the link 'http://localhost:3000'
		When I click "Contact US"
		Then I should see options for why to contact tcF
		And a text box allowing me to say what i want.


	Scenario: should not allow me to click more than one reason
		Given the link 'http://localhost:3000'
		When I click "Contact US"
		Then I should only be allowed to check one option for 
		why I want to contact tCF

	Scenario: should switch layout based on reason for contact
		Given the link 'http://localhost:3000'
		When I click "Contact us"
		When I click "Problem with a page"
		Then I should see a field to enter the faulty page
		And then I should be able to describe the problem

	Scenario: should switch layout based on reason for contact
		Given the link 'http://localhost:3000'
		When I click "Contact us"
		When I click "Other Question(s)"
		Then I should see a field to enter any other questions

	Scenario: should be able to choose to submit anonymously
		Given the link 'http://localhost:3000'
		When I click "Contact us"
		When I select "General Feedback"
		Then I should be able to choose to submit anonymously

	Scenario: should be able to choose to submit anonymously
		Given the link 'http://localhost:3000'
		When I click "Contact us"
		When I select "Problem with a page"
		Then I should be able to choose to submit anonymously
