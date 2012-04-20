Feature: Hints Activities
  In order to be productive
  An author
  Should create activities with hints

  Scenario: Create an activity with a pick a point sequence with hints
    Given I am on the Activities page
    When I create a new activity:
      """
      --- 
      :name: Hints Pick A Point
      :units:
      - :name: Time
        :abbreviation: s
      - :name: Distance
        :abbreviation: m
      :pages:
      - :name: Simple Page 1
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
        :sequence:
          :type: "PickAPointSequence"
          :title: Pick a point
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
    Given I am on the Activities page
    When I create a new activity:
      """
      --- 
      :name: Hints Numeric Sequence
      :units:
      - :name: Time
        :abbreviation: s
      - :name: Distance
        :abbreviation: m
      :pages:
      - :name: Simple Page 1
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
        :sequence:
          :type: "NumericSequence"
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

