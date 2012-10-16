Feature: Searching Activities
  In order to find public activities quickly
  An author
  Should be able to search activities.
  
  Background:
    Given these grade levels exist
      |name         |
      |1-3          |
      |2-4          |
      |5-8          |

    Given these subject areas exist
      |name         |
      |math         |
      |science      |
      |art          |

  Scenario: Searching by name
    Given these activities exist
      |name         | publication_status | grade_levels       | subject_areas         |
      |apple        | public             |                    |                       |
      |crab apple   | public             |                    |                       |
      |cherry       | public             |                    |                       |
      |secret       | private            |                    |                       |

    When I am on the search page
    And I search for "apple"
    And I click on search
    Then I should see "apple" in the search results
    And I should see "crab apple" in the search results
    And I should not see "cherry" in the search results
    And I should not see "secret" in the search results


  Scenario: Searching on one grade level
    Given these activities exist
      |name         | publication_status | grade_levels       | subject_areas         |
      |apple        | public             | 1-3                |                       |
      |crab apple   | public             |                    |                       |

    When I am on the search page
    And I check "1-3" for "grade_levels"
    And I click on search
    Then I should see "apple" in the search results
    And I should not see "crab apple" in the search results

  Scenario: Searching on two grade levels
    Given these activities exist
      |name         | publication_status | grade_levels       | subject_areas         |
      |apple        | public             | 1-3                |                       |
      |cherry       | public             | 2-4                |                       |
      |crab apple   | public             |                    |                       |

    When I am on the search page
    And I check "1-3" for "grade_levels"
    And I check "2-4" for "grade_levels"
    And I click on search
    Then I should see "apple" in the search results
    And  I should see "cherry" in the search results
    And I should not see "crab apple" in the search results

  Scenario: Searching on one subject area
    Given these activities exist
      |name         | publication_status | grade_levels       | subject_areas         |
      |apple        | public             |                    |                       |
      |cherry       | public             |                    | math                  |

    When I am on the search page
    And I check "math" for "subject_areas"
    And I click on search
    And I should see "cherry" in the search results
    And I should not see "apple" in the search results

  Scenario: Searching on two subject areas
    Given these activities exist
      |name         | publication_status | grade_levels       | subject_areas         |
      |orange       | public             |                    |                       |
      |berry        | public             |                    | art                   |
      |cherry       | public             |                    | math                  |

    When I am on the search page
    And I check "math" for "subject_areas"
    And I check "art" for "subject_areas"
    And I click on search
    And I should see "berry" in the search results
    And I should see "cherry" in the search results
    And I should not see "orange" in the search results


  Scenario: Searching by name, subject area, and grade
    Given these activities exist
      |name         | publication_status | grade_levels       | subject_areas         |
      |berry        | public             | 1-3                | art                   |
      |orange1      | public             | 1-3                | art                   |
      |orange2      | public             | 1-3                | math                  |
      |orange3      | public             | 2-4                | art                   |

    When I am on the search page
    And I check "1-3" for "grade_levels"
    And I check "art" for "subject_areas"
    And I search for "orange"
    And I click on search
    And I should see "orange1" in the search results
    And I should not see "berry" in the search results
    And I should not see "orange2" in the search results
    And I should not see "orange3" in the search results
