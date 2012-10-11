Feature: Basic Activities
  In order to be productive
  An author
  Should create and list basic activities

  Scenario: Create an activity
    Given I am logged in as an admin named 'admin'
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
    When  I create a new activity:
      """
      --- 
      :name: Simple Activity
      :author_name: Mr. Author
      :subject_areas:
      - Maths
      :grade_levels:
      - 10-12
      """
    Then The activity should be in the 'Maths' subject area
    And  The activity should be in the '10-12' grade level



  Scenario: Listing activities
    Given I am logged in as an admin named 'admin'
    And   I am on the index page
    Then I should see a link to "activities" in the navigation

  @javascript
  Scenario: Seeing grade levels in the listing
    Given I am logged in as an admin named 'admin'
    Given There is a grade level called  '10-12'
    When  I create a new activity:
      """
      --- 
      :name: Simple Activity
      :author_name: Mr. Author
      :grade_levels:
      - 10-12
      :publication_status: public
      """
    When I am on the Activities page
    Then I should see an activity listed for the grade level "10-12"

  @javascript
  Scenario: Seeing subject areas in the listing
    Given I am logged in as an admin named 'admin'
    Given There is a subject area called 'Maths'
    When  I create a new activity:
      """
      --- 
      :name: Simple Activity
      :author_name: Mr. Author
      :subject_areas:
      - Maths
      :publication_status: public
      """
    When I am on the Activities page
    Then I should see an activity listed for the subject area "Maths"

  Scenario: Listing my private activities
    Given I am logged in as an admin named 'admin'
    When  I create a new activity:
      """
      --- 
      :name: Simple Activity
      :author_name: Mr. Author
      :publication_status: private
      """
    Then I should see "Simple Activity" in my activities list

  Scenario: Private activities don't show up in index
    Given I am logged in as an admin named 'admin'
    When  I create a new activity:
      """
      --- 
      :name: My Private Activity
      :author_name: Mr. Author
      :publication_status: private
      """
    Then I should not see "My Private Activity" in the listing
