@javascript
Feature: Sign up for tCF
	In order to use theCourseForum
	As a UVA student I want to sign up

	Background:
		Given the homepage

	Scenario: page should be found
		Then I should see the Email and Password text fields