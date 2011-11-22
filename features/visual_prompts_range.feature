Feature: Range Visual Prompts Activities
  In order to be productive
  An author
  Should create activities with range visual prompts

  Scenario: Create an activity with a pick a point sequence with range visual prompts
    Given I am on the Activities page
    When I create a new activity:
      """
      --- 
      :name: Visual Prompt Range Pick A Point
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
          :initialPromptPrompts:
          - :type: RangeVisualPrompt
            :name: Red prompt
            :minX: 0
            :maxX: 5
            :color: red
          :correctAnswerX: 2
          :correctAnswerY: 200
          :giveUp: That's not right.
          :giveUpPrompts:
          - :type: RangeVisualPrompt
            :name: Green prompt
            :minX: 2
            :maxX: 3
            :color: green
          :confirmCorrect: Yes, that's right!
          :confirmCorrectPrompts:
          - :type: RangeVisualPrompt
            :name: Blue prompt
            :minX: 1
            :maxX: 4
            :color: blue
          :hints:
          - :name: Hint 1
            :text: Almost. Check the y axis.
            :prompts:
            - :type: RangeVisualPrompt
              :name: Yellow prompt
              :minX: -1
              :maxX: 6
              :color: yellow
      """
    Then I should get correct json

  Scenario: Create an activity with a numeric sequence with range visual prompts
    Given I am on the Activities page
    When I create a new activity:
      """
      --- 
      :name: Visual Prompt Range Numeric
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
          :title: Numeric
          :initialPrompt: Pick the middle point.
          :initialPromptPrompts:
          - :type: RangeVisualPrompt
            :name: Red prompt
            :minX: 0
            :maxX: 5
            :color: red
          :correctAnswer: 200
          :giveUp: That's not right.
          :giveUpPrompts:
          - :type: RangeVisualPrompt
            :name: Green prompt
            :minX: 2
            :maxX: 3
            :color: green
          :confirmCorrect: Yes, that's right!
          :confirmCorrectPrompts:
          - :type: RangeVisualPrompt
            :name: Blue prompt
            :minX: 1
            :maxX: 4
            :color: blue
          :hints:
          - :name: Hint 1
            :text: Almost. Check the y axis.
            :prompts:
            - :type: RangeVisualPrompt
              :name: Yellow prompt
              :minX: -1
              :maxX: 6
              :color: yellow
      """
    Then I should get correct json

