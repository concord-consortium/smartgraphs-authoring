Feature: Point Circle Prompts Activities
  In order to be productive
  An author
  Should create activities with point circle visual prompts

  @javascript
  Scenario: Create an activity with a pick a point sequence with point circle visual prompts
    Given I am logged in as an admin named 'admin'
    And   I am on the Activities page
    When I create a new activity:
      """
      --- 
      :name: Visual Prompt Point Circle Pick A Point
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
          :initialPromptPrompts:
          - :type: PointCircleVisualPrompt
            :name: Red prompt
            :pointX: 1
            :pointY: 100
            :color: red
          :correctAnswerX: 2
          :correctAnswerY: 200
          :giveUp: That's not right.
          :giveUpPrompts:
          - :type: PointCircleVisualPrompt
            :name: Green prompt
            :pointX: 2
            :pointY: 200
            :color: green
          :confirmCorrect: Yes, that's right!
          :confirmCorrectPrompts:
          - :type: PointCircleVisualPrompt
            :name: Blue prompt
            :pointX: 3
            :pointY: 300
            :color: blue
          :hints:
          - :name: Hint 1
            :text: Almost. Check the y axis.
            :prompts:
            - :type: PointCircleVisualPrompt
              :name: Yellow prompt
              :pointX: 4
              :pointY: 400
              :color: yellow
      """
    Then I should get correct json

  @javascript
  Scenario: Create an activity with a numeric sequence with point circle visual prompts
    Given I am logged in as an admin named 'admin'
    And   I am on the Activities page
    When I create a new activity:
      """
      --- 
      :name: Visual Prompt Point Circle Numeric
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
          :title: Numeric
          :initialPrompt: Pick the middle point.
          :initialPromptPrompts:
          - :type: PointCircleVisualPrompt
            :name: Red prompt
            :pointX: 1
            :pointY: 100
            :color: red
          :correctAnswer: 200
          :tolerance: 0.123
          :giveUp: That's not right.
          :giveUpPrompts:
          - :type: PointCircleVisualPrompt
            :name: Green prompt
            :pointX: 2
            :pointY: 200
            :color: green
          :confirmCorrect: Yes, that's right!
          :confirmCorrectPrompts:
          - :type: PointCircleVisualPrompt
            :name: Blue prompt
            :pointX: 3
            :pointY: 300
            :color: blue
          :hints:
          - :name: Hint 1
            :text: Almost. Check the y axis.
            :prompts:
            - :type: PointCircleVisualPrompt
              :name: Yellow prompt
              :pointX: 4
              :pointY: 400
              :color: yellow
      """
    Then I should get correct json

