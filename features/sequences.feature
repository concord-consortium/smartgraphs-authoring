Feature: Sequences Activities
  In order to be productive
  An author
  Should create activities with sequences

  Scenario: Create an activity with an instruction sequence
    Given I am on the Activities page
    When I create a new activity:
      """
      --- 
      :name: Sequences Instruction Sequence
      :pages:
      - :name: Simple Page 1
        :text: In this page...
        :sequence:
          :type: InstructionSequence
          :text: Click ok...
      """
    Then I should get correct json

  Scenario: Create an activity with a pick a point sequence
    Given I am on the Activities page
    When I create a new activity:
      """
      --- 
      :name: Sequences Pick A Point Sequence
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
      """
    Then I should get correct json

  Scenario: Create an activity with a pick a point within a range sequence
    Given I am on the Activities page
    When I create a new activity:
      """
      --- 
      :name: Sequences Pick A Point Within A Range Sequence
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
          :correctAnswerXMin: 2
          :correctAnswerYMin: 200
          :correctAnswerXMax: 3
          :correctAnswerYMax: 400
          :giveUp: That's not right.
          :confirmCorrect: Yes, that's right!
      """
    Then I should get correct json

  Scenario: Create an activity with a numeric sequence
    Given I am on the Activities page
    When I create a new activity:
      """
      --- 
      :name: Sequences Numeric Sequence
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
          :giveUp: That's not right.
          :confirmCorrect: Yes, that's right!
      """
    Then I should get correct json

  Scenario: Create an activity with a constructed response sequence
    Given I am on the Activities page
    When I create a new activity:
      """
      --- 
      :name: Sequences Constructed Response Sequence
      :pages:
      - :name: Simple Page 1
        :text: In this page...
        :sequence:
          :type: ConstructedResponseSequence
          :title: Constructed Response
          :initialPrompt: Tell me about...
          :initialContent: When I was...
      """
    Then I should get correct json

