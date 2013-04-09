Feature: Sequences Activities
  In order to be productive
  An author
  Should create activities with sequences

  Scenario: Create an activity with an instruction sequence
    Given I am logged in as an admin named 'admin'
    And   I am on the Activities page
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
    And I should be able to copy the activity

  @javascript
  Scenario: Create an activity with a pick a point sequence
    Given I am logged in as an admin named 'admin'
    And   I am on the Activities page
    When I create a new activity:
      """
      ---
      :name: Sequences Pick A Point Sequence
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
          :dataSet: default_data_set
          :title: Pick a point
          :initialPrompt: Pick the middle point.
          :correctAnswerX: 2
          :correctAnswerY: 200
          :giveUp: That's not right.
          :confirmCorrect: Yes, that's right!
      """
    Then I should get correct json
    And I should be able to copy the activity

  @javascript
  Scenario: Create an activity with a pick a point within a range sequence
    Given I am logged in as an admin named 'admin'
    And   I am on the Activities page
    When I create a new activity:
      """
      ---
      :name: Sequences Pick A Point Within A Range Sequence
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
          :dataSet: default_data_set
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
    And I should be able to copy the activity

  @javascript
  Scenario: Create an activity with a numeric sequence
    Given I am logged in as an admin named 'admin'
    And   I am on the Activities page
    When I create a new activity:
      """
      ---
      :name: Sequences Numeric Sequence
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
      """
    Then I should get correct json
    And I should be able to copy the activity

  Scenario: Create an activity with a constructed response sequence
    Given I am logged in as an admin named 'admin'
    And   I am on the Activities page
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
    And  I should be able to copy the activity

  @javascript
  Scenario: Create an activity with a multiple choice sequence with sequential feedback
    Given I am logged in as an admin named 'admin'
    And   I am on the Activities page
    When I create a new activity:
      """
      ---
      :name: Sequences Multiple Choice Sequence Sequential
      :units:
        - :name: Seconds
          :abbreviation: s
        - :name: Meters
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
        :xUnits: Seconds
        :yUnits: Meters
      :pages:
      - :name: Page 1
        :text: In this page...
        :sequence:
          :type: "MultipleChoiceSequence"
          :dataSetName: default_data_set
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
    And  I should be able to copy the activity

  @javascript
  Scenario: Create an activity with a multiple choice sequence with custom feedback
    Given I am logged in as an admin named 'admin'
    And   I am on the Activities page
    When I create a new activity:
      """
      ---
      :name: Sequences Multiple Choice Sequence Custom
      :units:
        - :name: Seconds
          :abbreviation: s
        - :name: Meters
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
        :xUnits: Seconds
        :yUnits: Meters
      :pages:
      - :name: Page 1
        :text: In this page...
        :sequence:
          :type: "MultipleChoiceSequence"
          :dataSetName: default_data_set
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
    And  I should be able to copy the activity

  @javascript
  Scenario: Create an activity with a type 'A' slope tool
    Given I am logged in as an admin named 'admin'
    And   I am on the Activities page
    When I create a new activity:
      """
      ---
      :name: Sequences Slope Tool Sequence A
      :units:
        - :name: Seconds
          :abbreviation: s
        - :name: Meters
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
        :xUnits: Seconds
        :yUnits: Meters

      :pages:
      - :name: Slope Tool Sequence Case A
        :text: Slope Tool Sequence Case A
        :panes:
        - :type: PredefinedGraphPane
          :title: Velocity
          :y:
            :label: Distance
            :min: 0.0
            :max: 10.0
            :ticks: 10
          :x:
            :label: Time
            :min: 0.0
            :max: 10.0
            :ticks: 10
          :data_sets:
          - default_data_set
        - :type: TablePane
          :title: data table
          :x_label: Time
          :y_label: Distance
        :sequence:
          :type: "SlopeToolSequence"
          :data_set_name: default_data_set
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
    And I should be able to copy the activity


  @javascript
  Scenario: Create an activity with a type 'b' slope tool
    Given I am logged in as an admin named 'admin'
    And   I am on the Activities page
    When I create a new activity:
      """
      ---
      :name: Sequences Slope Tool Sequence B
      :units:
        - :name: Seconds
          :abbreviation: s
        - :name: Meters
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
        :xUnits: Seconds
        :yUnits: Meters

      :pages:
      - :name: Slope Tool Sequence Case B
        :text: Slope Tool Sequence Case B
        :panes:
        - :type: PredefinedGraphPane
          :title: Velocity
          :y:
            :label: Distance
            :min: 0.0
            :max: 10.0
            :ticks: 10
          :x:
            :label: Time
            :min: 0.0
            :max: 10.0
            :ticks: 10
          :data_sets:
          - default_data_set
        - :type: TablePane
          :title: data table
          :x_label: Time
          :y_label: Distance
        :sequence:
          :type: "SlopeToolSequence"
          :data_set_name: default_data_set
          :case_type: "B: Ask Student To Pick A Point."
          :point_constraints: "Any Point Within The Range."
          :slope_variable_name: velocity
          :x_min: 2.0
          :x_max: 9.0
          :y_min: 1.0
          :y_max: 8.0
          :tolerance: 0.1
      """
    Then I should get correct json
    And I should be able to copy the activity

 @javascript
  Scenario: Create an activity with a type 'c' slope tool
    Given I am logged in as an admin named 'admin'
    And   I am on the Activities page
    When I create a new activity:
      """
      ---
      :name: Sequences Slope Tool Sequence C
      :units:
        - :name: Seconds
          :abbreviation: s
        - :name: Meters
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
        :xUnits: Seconds
        :yUnits: Meters

      :pages:
      - :name: Slope Tool Sequence Case C
        :text: Slope Tool Sequence Case C
        :panes:
        - :type: PredefinedGraphPane
          :title: Velocity
          :y:
            :label: Distance
            :min: 0.0
            :max: 10.0
            :ticks: 10
          :x:
            :label: Time
            :min: 0.0
            :max: 10.0
            :ticks: 10
          :data_sets:
          - default_data_set
        - :type: TablePane
          :title: data table
          :x_label: Time
          :y_label: Distance
        :sequence:
          :type: "SlopeToolSequence"
          :data_set_name: default_data_set
          :case_type: "C: Ask For Average Slope For The Region."
          :point_constraints: "Any Point Within The Range."
          :slope_variable_name: velocity
          :x_min: 2.0
          :x_max: 9.0
          :y_min: 1.0
          :y_max: 8.0
          :tolerance: 0.1
      """
    Then I should get correct json
    And I should be able to copy the activity


  @javascript
  Scenario: Create an activity with a slope tool which requires endpoint selection
    Given I am logged in as an admin named 'admin'
    And   I am on the Activities page
    When I create a new activity:
      """
      ---
      :name: Sequences Slope Tool Sequence Average
      :units:
        - :name: Seconds
          :abbreviation: s
        - :name: Meters
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
        :xUnits: Seconds
        :yUnits: Meters

      :pages:
      - :name: Sequences Slope Tool Sequence Average
        :text: Sequences Slope Tool Sequence Average
        :panes:
        - :type: PredefinedGraphPane
          :title: Velocity
          :y:
            :label: Distance
            :min: 0.0
            :max: 10.0
            :ticks: 10
          :x:
            :label: Time
            :min: 0.0
            :max: 10.0
            :ticks: 10
          :data_sets:
          - default_data_set
        - :type: TablePane
          :title: data table
          :x_label: Time
          :y_label: Distance
        :sequence:
          :type: "SlopeToolSequence"
          :data_set_name: default_data_set
          :case_type: "B: Ask Student To Pick A Point."
          :point_constraints: "Endpoints Of The Range."
          :slope_variable_name: velocity
          :x_min: 2.0
          :x_max: 9.0
          :y_min: 1.0
          :y_max: 8.0
          :tolerance: 0.1
      """
    Then I should get correct json
    And I should be able to copy the activity

  @javascript
  Scenario: Create an activity with a slope tool which requires adjacent selection
    Given I am logged in as an admin named 'admin'
    And   I am on the Activities page
    When I create a new activity:
      """
      ---
      :name: Sequences Slope Tool Sequence Adjacent
      :units:
        - :name: Seconds
          :abbreviation: s
        - :name: Meters
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
        :xUnits: Seconds
        :yUnits: Meters

      :pages:
      - :name: Sequences Slope Tool Sequence Adjacent
        :text: Sequences Slope Tool Sequence Adjacent
        :panes:
        - :type: PredefinedGraphPane
          :title: Velocity
          :y:
            :label: Distance
            :min: 0.0
            :max: 10.0
            :ticks: 10
          :x:
            :label: Time
            :min: 0.0
            :max: 10.0
            :ticks: 10
          :data_sets:
          - default_data_set
        - :type: TablePane
          :title: data table
          :x_label: Time
          :y_label: Distance
        :sequence:
          :type: "SlopeToolSequence"
          :data_set_name: default_data_set
          :case_type: "B: Ask Student To Pick A Point."
          :point_constraints: "Adjacent Points Within The Range."
          :slope_variable_name: velocity
          :x_min: 2.0
          :x_max: 9.0
          :y_min: 1.0
          :y_max: 8.0
          :tolerance: 0.1
      """
    Then I should get correct json
    And I should be able to copy the activity

  @javascript
  Scenario: Create an activity with a line of best fit sequence
    # Note that this also tests adding more than one dataset to a GraphPane
    Given I am logged in as an admin named 'admin'
    And   I am on the Activities page
    When I create a new activity:
      """
      ---
      :name: Sequences Best Fit Sequence
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
          5,500
          6,600
        :xUnits: Time
        :yUnits: Distance
      - :name: learner_data_set
        :yPrecision: 0.1
        :xPrecision: 0.1
        :lineSnapDistance: 0.1
        :expression:
        :lineType: Connected
        :pointType: None
        :data:
        :xUnits: Time
        :yUnits: Distance
      :pages:
      - :name: Best Fit Sequence Page 1
        :text: On this page, students will be asked to find the line of best fit for a series of points.
        :panes:
        - :type: PredefinedGraphPane
          :title: Line Construction Graph Pane
          :y:
            :label: y
            :min: 0.0
            :max: 10
            :ticks: 10
          :x:
            :label: x
            :min: 0
            :max: 10
            :ticks: 10
          :data_sets:
          - default_data_set
          - learner_data_set
        - :type: TablePane
          :title: Best Fit table
          :x_label: x
          :y_label: y
        :sequence:
          :type: "BestFitSequence"
          :data_set_name: default_data_set
          :learner_data_set_name: learner_data_set
          :correct_tolerance: 0.1
          :close_tolerance: 0.2
          :max_attempts: 2
          :initial_prompt: Find the line of best fit for this scatter plot.
          :incorrect_prompt: Your estimate can be better; try again.
          :close_prompt: Your estimate is close; try again.
          :confirm_correct: You made an excellent estimate.
      """
    Then I should get correct json
    And I should be able to copy the activity

  @javascript
  Scenario: Create an activity with a label sequence
    Given I am logged in as an admin named 'admin'
    And   I am on the Activities page
    When I create a new activity:
      """
      ---
      :name: Sequences Label Sequence
      :units:
      - :name: Time
        :abbreviation: s
      - :name: meters
        :abbreviation: m
      :data_sets:
      - :name: default_data_set
        :yPrecision: 0.1
        :xPrecision: 0.1
        :lineSnapDistance: 0.1
        :expression: y  = 0.8 sin(x)
        :lineType: Connected
        :pointType: Dot
        :xUnits: Time
        :yUnits: meters
      :pages:
      - :name: Label Sequence Page 1
        :text: On this page, students will be asked to place a label on the graph.
        :panes:
        - :type: PredefinedGraphPane
          :title: Sinusoidal motion
          :y:
            :label: Distance
            :min: -1.0
            :max: 1.0
            :ticks: 10.0
          :x:
            :label: Time
            :min: -4.0
            :max: 4.0
            :ticks: 16.0
          :data_sets:
          - default_data_set
        :sequence:
          :type: "LabelSequence"
          :text: Label the zero crossings
          :label_count: 3
      - :name: Label Sequence Page 2
        :text: The following is a graph of 0.8 sin(x), with the zero crossings you labeled.
        :panes:
        - :type: PredefinedGraphPane
          :title: Sinusoidal motion
          :y:
            :label: Distance
            :min: -1.0
            :max: 1.0
            :ticks: 10.0
          :x:
            :label: Time
            :min: -4.0
            :max: 4.0
            :ticks: 16.0
          :data_sets:
          - default_data_set
          :label_sets:
          - Labels for Lorem
      """
    Then I should get correct json
    And I should be able to copy the activity
