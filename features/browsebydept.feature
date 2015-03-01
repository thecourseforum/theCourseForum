Feature: Browse by department/all 
	Choose classes by selecting departments

	Scenario: page should be found
		Given the link 'http://localhost:3000'
		Then I should see the Arts & Sciences Department
		And I should see the Engineering & Applied Sciences
		And I should see other schools at the University of 			Virginia

	Scenario: subdepartments should be listed
		Given the link 'http://localhost:3000'
		When I see the Arts & Sciences Department
		When East Asian Languages, Literatures & Cultures  
		department is clicked
		Then I should see all subdepartments in East Asian 
		Languages, Literatures & Cultures 
		And headers with their classes listed below them

	Scenario: professors who have taught the course should be 
		listed
		Given the link 'http://localhost:3000'
		When I see the Arts & Sciences Department
		When East Asian Languages, Literatures & Cultures  
		department is clicked
		When CHIN 1020 - Elementary Chinese is clicked
		Then I should see all professors that have taught 
		CHIN 1020 - Elementary Chinese 
		Then the professors should be listed 
		Then their number of reviews should be listed
		Then the ratings for each professor should be listed 

	Scenario: professor is clicked from a list of professors
		Given the link 'http://localhost:3000'
		When I see the Arts & Sciences Department
		When East Asian Languages, Literatures & Cultures  
		department is clicked
		When CHIN 1020 - Elementary Chinese is clicked
		When Professor Ran Zhao is clicked
		Then CHIN 1020 - Elementary Chinese should appear 
		Then a menu to select different professors should 			appear
		Then "Write a Review" button should appear
		Then Professor Ran Zhao's ratings should appear
		Then Professor Ran Zhao's grade distribution should 
		appear
		Then the "types of homework" Professor Ran Zhao 
		emphasizes should appear 
		Then the number of reviews and comments for this class
		should appear
		Then a "sort by" label should appear with a drop down 
		menu
		Then Professor Ran Zhao's reviews should be listed
  
	Scenario: page should be found
		Given the link 'http://localhost:3000'
		Then I should see each schools and only their 
		departments listed as clickable links

	Scenario: subdepartments should be listed
		Given the link 'http://localhost:3000'
		When the Psychology department is clicked
		Then I should see all subdepartments in Psychology 			And their classes should be listed below them

	Scenario: professors who have taught the course should be 
		listed
		Given the link 'http://localhost:3000'
		When the Psychology department is clicked
		When PSYC 2210 Animal Behavior is clicked
		Then I should see all professors that have taught 
		PSYC 2210 Animal Behavior
		Then the number of reviews for each professor should 
		be listed 
		Then the ratings for each professor should be listed  

	Scenario: professor is clicked from a list of professors
		Given the link 'http://localhost:3000'
		When East Asian Languages, Literatures & Cultures  
		department is clicked
		When the Psychology department is clicked
		When PSYC 2210 Animal Behavior is clicked
		When Professor Chad Meliza is clicked
		Then PSYC 2210 Animal Behavior should appear
		Then a menu to select different professors should 			appear
		Then "Write a Review" button should appear
		Then Professor Chad Meliza's ratings should appear
		Then Professor Chad Meliza's grade distribution should 
		appear
		Then the "types of homework" Professor Chad Meliza 
		emphasizes should appear
		Then the number of reviews and comments for PSYC 2210 
		Animal Behavior	should appear
		Then a "sort by" label should appear with a drop down 
		menu to select ways to sort the reviews (most recent,
		most helpful, etc.)
		Then Professor Chad Meliza's reviews should be listed
