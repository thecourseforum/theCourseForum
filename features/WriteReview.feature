Feature: Write a tCF Review
	As a main feature on theCourseForum
	I want to be able to write a review

	Scenario: page should be found
		Given the link 'http://localhost:3000'
		When I click on Write a Review
		Then I should see 'Write a Review', fields for department,course,professor, grades, 			and a text field.

	Scenario: should be able to select a valid department
		Given the link'http://localhost:3000'
		When I click on Write a Review
		Then I should be able to click on the "Department" dropdown and see every valid 		department and no other department.

	Scenario: should be able to select a valid course
		Given the link 'http://localhost:3000'
		When I click on Write a Review
		When I click on the department ACCT
		Then I should only be able to select ACCT courses.

	Scenario: should be able to select a valid course
		Given the link 'http://localhost:3000'
		When I click on Write a Review
		When I click on the department CHEM
		Then I should only be able to select CHEM courses.

	Scenario: should be able to select a valid professor
		Given the link 'http://localhost:3000'
		When I click on Write a Review
		When I click on the department ACCT
		When I click the course 2010
		Then I should be able to click on professor Brooks.

	Scenario: should be able to select a valid professor
		Given the linke 'http://localhost:3000'
		When I click on Write a Review
		When I click on the department CHEM
		When I click on the course 1410
		Then I should be able to click on professor Metcalf
