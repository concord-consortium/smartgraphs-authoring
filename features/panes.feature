Feature: Pane Activities
  In order to be productive
  An author
  Should create activities with panes

  Scenario: Create an activity with an image pane
    Given I am logged in as an admin named 'admin'
    And   I am on the Activities page
    When I create a new activity:
      """
      --- 
      :name: Panes Image Pane
      :pages:
      - :name: Simple Page 1
        :text: In this page...
        :panes:
        - :type: ImagePane
          :name: Image Pane
          :url: http://www.concord.org/images/foo.png
          :license: Creative Commons
          :attribution: The Concord Consortium
      """
    Then I should get correct json

  Scenario: Create an activity with a predefined graph pane
    Given I am logged in as an admin named 'admin'
    And   I am on the Activities page
    When I create a new activity:
      """
      --- 
      :name: Panes Predefined Graph Pane
      :units:
      - :name: Time
        :abbreviation: s
      - :name: Distance
        :abbreviation: m
      :data_sets:
      - :name: default_data_set
        :yPrecision: 0.1
        :xPrecision: 0.1
        :lineSnapDistance: 0.1
        :expression:
        :lineType: None
        :pointType: Dot
        :data: |-
          1,100
          2,200
          3,300
          4,400
        :xUnits: Time
        :yUnits: Distance
      :pages:
      - :name: Simple Page 1
        :text: In this page...
        :panes:
        - :type: PredefinedGraphPane
          :title: Graph Pane
          :y:
            :label: Distance
            :min: 0
            :max: 10
            :ticks: 1
          :x:
            :label: Time
            :min: 0
            :max: 10
            :ticks: 1
          :data_sets: 
          - default_data_set
      """
    Then I should get correct json
    And I should be able to copy the activity

  Scenario: Create an activity with a sensor graph pane
    Given I am logged in as an admin named 'admin'
    And   I am on the Activities page
    When I create a new activity:
      """
      --- 
      :name: Panes Sensor Graph Pane
      :units:
      - :name: Time
        :abbreviation: s
      - :name: Distance
        :abbreviation: m
      :pages:
      - :name: Simple Page 1
        :text: In this page...
        :panes:
        - :type: SensorGraphPane
          :title: Graph Pane
          :y:
            :label: Distance
            :unit: Distance
            :min: 0
            :max: 10
            :ticks: 1
          :x:
            :label: Time
            :unit: Time
            :min: 0
            :max: 10
            :ticks: 1
      """
    Then I should get correct json
    And I should be able to copy the activity

  Scenario: Create an activity with a table pane
    Given I am logged in as an admin named 'admin'
    And   I am on the Activities page
    When I create a new activity:
      """
      --- 
      :name: Panes Table Pane
      :pages:
      - :name: Simple Page 1
        :text: In this page...
        :panes:
        - :type: TablePane
          :title: Table Pane
      """
    Then I should get correct json

  Scenario: Create an activity with a prediction graph pane
    Given I am logged in as an admin named 'admin'
    And   I am on the Activities page
    When I create a new activity:
      """
      --- 
      :name: Panes Prediction Graph Pane
      :units:
      - :name: Time
        :abbreviation: s
      - :name: Distance
        :abbreviation: m
      :pages:
      - :name: Simple Page 2
        :text: In this page...
        :panes:
        - :type: PredictionGraphPane
          :title: Graph Pane
          :y:
            :label: Distance
            :unit: Distance
            :min: 0
            :max: 10
            :ticks: 1
          :x:
            :label: Time
            :unit: Time
            :min: 0
            :max: 10
            :ticks: 1
          :prediction_type: Connecting Points
      - :name: Simple Page 3
        :text: In this page...
        :panes:
        - :type: PredictionGraphPane
          :title: Graph Pane
          :y:
            :label: Distance
            :unit: Distance
            :min: 0
            :max: 10
            :ticks: 1
          :x:
            :label: Time
            :unit: Time
            :min: 0
            :max: 10
            :ticks: 1
          :prediction_type: Continuous Curves
      """
    Then I should get correct json
    And I should be able to copy the activity

