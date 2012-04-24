Feature: Basic Activities
  In order to be productive
  An author
  Should create basic activities

  Scenario: Create an activity
    Given I am logged in as an admin named 'admin'
    And   I am on the Activities page
    When  I create a new activity:
      """
      --- 
      :name: Simple Activity
      :author_name: Mr. Author
      :pages:
      - :name: Simple Page 1
        :text: In this page...
      - :name: Simple Page 2
        :text: Now, in this other page...
      """
    Then I should get correct json

