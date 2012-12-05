Feature: Hints Activities
  In order to be productive
  An author
  Should create activities with hints

  @javascript
  Scenario: Create an activity with a pick a point sequence with hints
    Given I am logged in as an admin named 'admin'
    And   I am on the Activities page
    When I create a new activity:
      """
      --- 
      :name: Hints Pick A Point
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
        :sequence:
          :type: "PickAPointSequence"
          :title: Pick a point
          :dataSet: default_data_set
          :initialPrompt: Pick the middle point.
          :correctAnswerX: 2
          :correctAnswerY: 200
          :giveUp: That's not right.
          :confirmCorrect: Yes, that's right!
          :hints:
          - :name: Hint 1
            :text: Almost. Check the y axis.
          - :name: Hint 2
            :text: Line it up.
      """
    Then I should get correct json

  Scenario: Create an activity with a numeric sequence with hints
    Given I am logged in as an admin named 'admin'
    And   I am on the Activities page
    When I create a new activity:
      """
      --- 
      :name: Hints Numeric Sequence
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
        :sequence:
          :type: "NumericSequence"
          :dataSet: default_data_set
          :title: Enter a number
          :initialPrompt: What is the value at x=2?
          :correctAnswer: 200
          :tolerance: 0.123
          :giveUp: That's not right.
          :confirmCorrect: Yes, that's right!
          :hints:
          - :name: Hint 1
            :text: Almost. Check the y axis.
          - :name: Hint 2
            :text: Line it up.
      """
    Then I should get correct json

