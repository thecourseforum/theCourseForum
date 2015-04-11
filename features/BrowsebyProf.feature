Feature: Browse by Professor
	In order to add/review classes, I 
	need to be able to browse by Professor.

	Background:
		Given a user is logged in

	Scenario: page should be found
		Given the link 'http://localhost:3000/
		When I click on Browse by Professor
		Then I should see 'First Letter of Professor's Last Name' and a dropdown option

	Scenario: should display correct courses
		Given the link 'http://localhost:3000/
		When I click on Browse by Professor
		When I drop down and click the letter 'A'
		When I click on Abramenko, Monika
		Then I should see the courses APMA 1110, APMA 3080, APMA 8897, & MATH 1140

	Scenario: should display proper display course page
		Given the link 'http://localhost:3000/
		When I click on Browse by Professor
		When I drop down and click the letter 'A'
		When I click on Abramenko, Monika
		When I click on APMA 3080
		Then I should see reviews, a switch professor dropdown, along with grade distributions

	Scenario: should display correct courses
		Given the link 'http://localhost:3000/
		When I click on Browse by Professor
		When I drop down and click the letter 'C'
		When I click on Cai, Luoyi
		Then I should see the courses CHIN 1020, CHIN 4010, & CHIN 7010.

	Scenario: should display proper display course page
		Given the link 'http://localhost:3000/
		When I click on Browse by Professor
		When I drop down and click the letter 'C'
		When I click on Cai, Luoyi
		When I click on CHIN 4010
		Then I should see reviews, a switch professor dropdown, along with grade distributions.







