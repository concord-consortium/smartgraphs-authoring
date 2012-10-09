Feature: Basic Activities
  In order to be productive
  An author
  Should create and list basic activities

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

  Scenario: Create a public activity
    Given I am logged in as an admin named 'admin'
    And   I am on the Activities page
    When  I create a new activity:
      """
      --- 
      :name: Simple Activity
      :author_name: Mr. Author
      :publication_status: public
      :pages:
      - :name: Simple Page 1
        :text: In this page...
      - :name: Simple Page 2
        :text: Now, in this other page...
      """
    Then The activity should be public

  Scenario: Create a public activity
    Given I am logged in as an admin named 'admin'
    And   I am on the Activities page
    When  I create a new activity:
      """
      --- 
      :name: Simple Activity
      :author_name: Mr. Author
      :publication_status: private
      :pages:
      - :name: Simple Page 1
        :text: In this page...
      - :name: Simple Page 2
        :text: Now, in this other page...
      """
    Then The activity should be private

  @javascript
  Scenario: Create an activity with a grade level and subject area
    Given I am logged in as an admin named 'admin'
    Given There is a grade level called  '10-12'
    Given There is a subject area called 'Maths'
    And   I am on the Activities page
    When  I create a new activity:
      """
      --- 
      :name: Simple Activity
      :author_name: Mr. Author
      :subject_areas:
      - Maths
      :grade_levels:
      - 10-12
      :pages:
      - :name: Simple Page 1
        :text: In this page...
      - :name: Simple Page 2
        :text: Now, in this other page...
      """
    Then The activity should be in the 'Maths' subject area
    And  The activity should be in the '10-12' grade level

  Scenario: Listing activities
    Given I am logged in as an admin named 'admin'
    And   I am on the index page
    Then I should see a link to "activities" in the navigation

  Scenario: Listing my activities
    Given I am logged in as an admin named 'admin'
    And I am on the Activities page
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
    And I am on the index page
    Then I should see a link to "activities/my_activities" in the navigation
    When I am on My Activities page
    Then I should see "Simple Activity" in the listing