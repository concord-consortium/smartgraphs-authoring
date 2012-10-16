Feature: Basic Activities
  In order to be productive
  An author
  Should create basic activities

  Scenario: Bob and Joe cant edit each others activities
    Given I am logged in as a user named 'bob'
    And   I create a new activity:
      """
      --- 
      :name: Bob's Activity
      :author_name: bob
      :publication_status: public
      """
    Then I should see "Bob's Activity" in the listing
    And  I should be able to edit "Bob's Activity"


    When I am logged in as a user named 'joe'
    And  I create a new activity:
      """
      --- 
      :name: Joe's Activity
      :author_name: Joe
      :publication_status: public
      """
    Then I should see "Bob's Activity" in the listing
    And  I should see "Joe's Activity" in the listing
    And  I should not be able to edit "Bob's Activity"
    And  I should be able to edit "Joe's Activity"
    And  I should be able to change the name of "Joe's Activity"