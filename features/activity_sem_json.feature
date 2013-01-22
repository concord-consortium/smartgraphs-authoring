Feature: Basic Activities
  In order to be productive
  An author
  Should create and list basic activities

  Scenario: Create an activity
    Given I am logged in as an admin named 'admin'
    When  I create a "Simple Activity" from semantic json
    Then I should get correct json

  Scenario: Create a public activity
    Given I am logged in as an admin named 'admin'
    When  I create a "Simple Activity" from semantic json
    Then The activity should be private

