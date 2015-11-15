@javascript
Feature: Navigate the site
  In order to browse pages on theCourseForum
  I want to be able to search for professors

  Background:
    Given a course professor exists
    Given a user is logged in
    Given courses exist

  Scenario: should be able to go from the browse all page to a specific course professor
    Given the browse all page
    Then I should see 'Computer Science'
    Then I should see 'CS 2150'
    Then I should see 'Aaron Bloomfield'

  Scenario: should be able to toggle between current semester and all semesters
    Given the 'Special Topics in Computer Science' page
    Then I should not see David Evans
    And I click on 'All'
    Then I should see David Evans

  Scenario: should be able to toggle between the three professor parameters
    Given the 'Theory of Computation' page
    Given the 'All'
    Given the 'Rating' parameter
    Then I should see 'Worthy Martin' as the second professor
    Then I click on 'Difficulty'
    And I should see 'Worthy Martin' as the third professor
    Then I click on 'GPA'
    And I should see 'Worthy Martin' as the fourth professor

  Scenario: should be able to see 'Tychonovich, Luther'
    Given the 'CS 1110- Introduction to Programming' page
    Then I should see 'Tychonovich, Luther'

  Scenario: should be able to type to find a professor
    Given the 'Theory of Computation' page
    When I click on the professor dropdown
    And I type 'T'
    Then I should see 'Tychonovich, Luther'

  Scenario: should be able to select classes from the autocomplete box
    Given the home page
    When I click on the search box
    And I type 'CS 2150'
    Then I should see 'CS 2150 - Program and Data Representation'
    And I should click 'CS 2150 - Program and Data Representation'
    Then I should see 'Program and Data Representation'

  Scenario: should be able to search for a class
    Given the home page
    When I click on the search box
    And I type '2150'
    And I press enter
    Then I should see 5 courses

  Scenario: should be able to search for a professor
    Given the home page
    When I click on the search box
    And I type 'Bloomfield'
    And I press enter
    Then I should see 2 professors