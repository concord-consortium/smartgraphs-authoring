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
          :tolerance: 0.123
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

  @javascript
  Scenario: Create an activity with a multiple choice sequence with sequential feedback
    Given I am on the Activities page
    When I create a new activity:
      """
      --- 
      :name: Sequences Multiple Choice Sequence Sequential
      :pages:
      - :name: Page 1
        :text: In this page...
        :sequence:
          :type: "MultipleChoiceSequence"
          :initialPrompt: Whats the blah blah.
          :giveUp: That's not right.
          :confirmCorrect: Yes, that's right!
          :useSequentialFeedback: true
          :choices:
          - :name: choice a
            :correct: false
            :feedback: this aint right
          - :name: choice b
            :correct: true
            :feedback: You got it!
          - :name: choice c
            :correct: false
            :feedback: try choice B instead.
          :hints:
          - :name: feedback 1
            :feedback: this aint right
          - :name: feedback 2
            :feedback: try choice B instead.
      """
    Then I should get correct json

  @javascript
  Scenario: Create an activity with a multiple choice sequence with custom feedback
    Given I am on the Activities page
    When I create a new activity:
      """
      --- 
      :name: Sequences Multiple Choice Sequence Custom
      :pages:
      - :name: Page 1
        :text: In this page...
        :sequence:
          :type: "MultipleChoiceSequence"
          :initialPrompt: Whats the blah blah.
          :giveUp: That's not right.
          :confirmCorrect: Yes, that's right!
          :useSequentialFeedback: false
          :choices:
          - :name: choice a
            :correct: false
            :feedback: this aint right
          - :name: choice b
            :correct: true
            :feedback: You got it!
          - :name: choice c
            :correct: false
            :feedback: try choice B instead.
          :hints:
          - :name: feedback 1
            :feedback: this aint right
          - :name: feedback 2
            :feedback: try choice B instead.
      """
    Then I should get correct json

  @javascript
  Scenario: Create an activity with a multiple choice sequence with custom feedback
    Given I am on the Activities page
    When I create a new activity:
      """
      --- 
      :name: Sequences Slope Tool Sequence A
      :units:
        - :name: Seconds
          :abbreviation: s
        - :name: Meters
          :abbreviation: m
      :pages:
      - :name: Slope Tool Sequence Case A
        :text: Slope Tool Sequence Case A
        :panes:
        - :type: PredefinedGraphPane
          :title: Velocity
          :y:
            :label: Distance
            :unit: Meters
            :min: 0.0
            :max: 10.0
            :ticks: 10
          :x:
            :label: Time
            :unit: Seconds
            :min: 0.0
            :max: 10.0
            :ticks: 10
          :data: |-
            0.0,0.0
            1.0,0.0
            2.0,1.0
            3.0,2.0
            4.0,3.0
            5.0,4.0
            6.0,5.0
            7.0,6.0
            8.0,7.0
            9.0,8.0
            10.0,7.0
        - :type: TablePane
          :title: data table
        :sequence:
          :type: "SlopeToolSequence"
          :case_type: "A: Ask A Slope Question."
          :point_constraints: "Any Point Within The Range."
          :first_question: "What is the average velocity between 2 and 9 seconds (in m / s)?"
          :slope_variable_name: velocity
          :x_min: 2.0
          :x_max: 9.0
          :y_min: 1.0
          :y_max: 8.0    
          :tolerance: 0.1
      """
    Then I should get correct json