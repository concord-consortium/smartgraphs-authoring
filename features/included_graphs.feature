Feature: Included Graphs Activities
  In order to be productive
  An author
  Should create activities with graphs that include data from other prediction graphs

  @javascript
  Scenario: Create an activity with a predefined graph pane with included prediction graph data
    Given I am logged in as an admin named 'admin'
    And   I am on the Activities page
    When I create a new activity:
      """
      --- 
      :name: Included Graphs Predefined Graph Pane
      :units:
      - :name: Time
        :abbreviation: s
      - :name: Distance
        :abbreviation: m
      :pages:
      - :name: Simple Page 1
        :text: In this page...
        :panes:
        - :type: PredictionGraphPane
          :title: Prediction 1
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
      - :name: Simple Page 2
        :text: In this page...
        :panes:
        - :type: PredefinedGraphPane
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
          :data: |-
            1,100
            2,200
            3,300
            4,400
          :included_graphs:
          - Prediction 1
      """
    Then I should get correct json

  @javascript
  Scenario: Create an activity with a sensor graph pane with included prediction graph data
    Given I am logged in as an admin named 'admin'
    And   I am on the Activities page
    When I create a new activity:
      """
      --- 
      :name: Included Graphs Sensor Graph Pane
      :units:
      - :name: Time
        :abbreviation: s
      - :name: Distance
        :abbreviation: m
      :pages:
      - :name: Simple Page 1
        :text: In this page...
        :panes:
        - :type: PredictionGraphPane
          :title: Prediction 1
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
      - :name: Simple Page 2
        :text: In this page...
        :panes:
        - :type: PredictionGraphPane
          :title: Prediction 2
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
      - :name: Simple Page 3
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
          :included_graphs:
          - Prediction 1
          - Prediction 2
      """
    Then I should get correct json

  @javascript
  Scenario: Create an activity with a prediction graph pane with included prediction graph data
    Given I am logged in as an admin named 'admin'
    And   I am on the Activities page
    When I create a new activity:
      """
      --- 
      :name: Included Graphs Prediction Graph Pane
      :units:
      - :name: Time
        :abbreviation: s
      - :name: Distance
        :abbreviation: m
      :pages:
      - :name: Simple Page 1
        :text: In this page...
        :panes:
        - :type: PredictionGraphPane
          :title: Prediction 1
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
        - :type: PredictionGraphPane
          :title: Prediction 2
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
          :included_graphs:
          - Prediction 1
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
          :included_graphs:
          - Prediction 2
      """
    Then I should get correct json

