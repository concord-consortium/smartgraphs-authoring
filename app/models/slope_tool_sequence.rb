class SlopeToolSequence < ActiveRecord::Base
  hobo_model # Don't put anything above this

  CaseType = HoboFields::Types::EnumString.for(:case_a, :case_b, :case_c)

  fields do
    case_type                              SlopeToolSequence::CaseType,   :default => 'A'
    first_question                         :text
    student_must_select_endpoints_of_range :boolean,  :default => false
    slope_variable_name                    :string
    x_min                                  :float,    :default => 0
    y_min                                  :float,    :default => 0
    x_max                                  :float,    :default => 10
    y_max                                  :float,    :default => 10
    selected_points_must_be_adjacent       :boolean,  :default => false
    tolerance                              :float,    :default => 0.1
    timestamps
  end

  has_one :page_sequence, :as => :sequence, :dependent => :destroy
  has_one :page, :through => :page_sequence
  reverse_association_of :page, 'Page#slope_tool_sequences'

  def parent
    page
  end
        # "type": "SlopeToolSequence",
        # "firstQuestionIsSlopeQuestion": true,
        # "firstQuestion": "What is the average velocity between 0 to 10 seconds?",
        # "studentSelectsPoints": true,
        # "studentMustSelectEndpointsOfRange": true,
        # "slopeVariableName": "velocity",
        # "xMin": 0,
        # "xMax": 10,
        # "yMin": 0,
        # "yMax": 12,
        # "selectedPointsMustBeAdjacent": false,
        # "tolerance": 0.1
  def to_hash
    {
      'type' => type,
      'firstQuestionIsSlopeQuestion' => first_question_is_slope_question,
      'firstQuestion' => first_question,
      'studentSelectsPoints' => student_selects_points,
      'slopeVariableName' => slope_variable_name,
      'xMin' => x_min,
      'xMax' => x_max,
      'yMin' => y_min,
      'yMax' => y_max,
      'selectedPointsMustBeAdjacent' => selected_points_must_be_adjacent,
      'tolerance' => tolerance
    }
  end

  def type
    "SlopeToolSequence"
  end

  #first_question_is_slope_question       :boolean,  :default => true
  def first_question_is_slope_question
    return case case_type
      when :case_a then true
      when :case_c then true
      else false
    end
  end

  #student_selects_points                 :boolean,  :default => true
  def student_selects_points
    return case case_type
      when :case_a then true
      when :case_b then true
      else false
    end
  end


  def validate_case_type(c_type)
    return true if CaseTypes.include? c_type
  end

  # --- Permissions --- #

  def create_permitted?
    acting_user.administrator?
  end

  def update_permitted?
    acting_user.administrator?
  end

  def destroy_permitted?
    acting_user.administrator?
  end

  def view_permitted?(field)
    true
  end

end
