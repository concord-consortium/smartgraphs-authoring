class SlopeToolSequence < ActiveRecord::Base
  hobo_model # Don't put anything above this
  
  # standard owner and admin permissions
  # defined in models/standard_permissions.rb
  include SgPermissions
  include SgMarshal
  sg_parent :page

  CaseType        = HoboFields::Types::EnumString.for(:case_a, :case_b,    :case_c)
  PointConstraint = HoboFields::Types::EnumString.for(:any,    :endpoints, :adjacent)

  fields do
    case_type                              SlopeToolSequence::CaseType,         :default => "case_a"
    point_constraints                      SlopeToolSequence::PointConstraint,  :default => "any"

    first_question                         :text
    slope_variable_name                    :string,   :default => "slope"
    x_min                                  :float,    :default => 0
    y_min                                  :float,    :default => 0
    x_max                                  :float,    :default => 10
    y_max                                  :float,    :default => 10
    
    tolerance                              :float,    :default => 0.1
    timestamps
  end

  has_one :page_sequence, :as => :sequence, :dependent => :destroy
  has_one :page, :through => :page_sequence
  reverse_association_of :page, 'Page#slope_tool_sequences'

  def to_hash
    {
      'type'                              => type,
      'firstQuestionIsSlopeQuestion'      => first_question_is_slope_question,
      'firstQuestion'                     => first_question,
      'studentSelectsPoints'              => student_selects_points,
      'studentMustSelectEndpointsOfRange' => student_must_select_endpoints_of_range,
      'slopeVariableName'                 => slope_variable_name,

      'xMin' => x_min,
      'xMax' => x_max,
      'yMin' => y_min,
      'yMax' => y_max,
      'selectedPointsMustBeAdjacent'      => selected_points_must_be_adjacent,
      'tolerance' => tolerance
    }
  end

  def type
    "SlopeToolSequence"
  end

  #first_question_is_slope_question       :boolean,  :default => true
  def first_question_is_slope_question
    return case case_type
      when "case_a" then true
      when "case_c" then true
      else false
    end
  end

  #student_selects_points                 :boolean,  :default => true
  def student_selects_points
    return case self.case_type
      when "case_a" then true
      when "case_b" then true
      else false
    end
  end

  # student_must_select_endpoints_of_range :boolean,  :default => false
  def student_must_select_endpoints_of_range
    self.point_constraints == "endpoints"
  end

  # selected_points_must_be_adjacent       :boolean,  :default => false
  def selected_points_must_be_adjacent
    self.point_constraints == "adjacent"
  end

  def validate_point_constraints
    return true if PointConstraints.include? c_type
  end

  def validate_case_type(c_type)
    return true if CaseTypes.include? c_type
  end

  def selected_points_must_be_adjacent_from_hash(definition)
    if definition == true
      self.point_constraints = "adjacent"
    else
      if self.point_constraints == "adjacent"
        self.point_constraints = "any"
      end
    end
  end

  def student_must_select_endpoints_of_range_from_hash(definition)
    if definition == true
      self.point_constraints = "endpoints"
    else
      if self.point_constraints = "endpoints"
        self.point_constraints = "any"
      end
    end
  end

  def student_selects_points_from_hash(definition)
    if definition == true
      if self.first_question_is_slope_question
        self.case_type = "case_a"
      else
        self.case_type = "case_b"
      end
    else
      self.case_type = "case_c"
    end
  end

  def first_question_is_slope_question_from_hash(definition)
    if definition == true
      if student_selects_points
        self.case_type = "case_a" 
      else
        self.case_type = "case_c"
      end
    else
      self.case_type="case_b"
    end
  end  

end
