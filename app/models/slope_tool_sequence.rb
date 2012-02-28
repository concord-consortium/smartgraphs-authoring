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
  #first_question_is_slope_question       :boolean,  :default => true
  def first_question_is_slope_question
    return case case_type
      when CaseA then true
      when CaseC then true
      else false
    end
  end

  #student_selects_points                 :boolean,  :default => true
  def student_selects_points
    return case case_type
      when CaseA then true
      when CaseB then true
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
