class PickAPointSequence < ActiveRecord::Base

  hobo_model # Don't put anything above this

  # standard owner and admin permissions
  # defined in models/standard_permissions.rb
  include SgPermissions
  include SgMarshal
  include SgSequencePrompts

  sg_parent :page
  
  fields do
    title             :string
    initial_prompt    :raw_html
    answer_with_label :boolean
    give_up           :raw_html
    confirm_correct   :raw_html

    # support for a distinct point
    correct_answer_x :float
    correct_answer_y :float

    # support for a point within a range
    correct_answer_x_min :float
    correct_answer_y_min :float
    correct_answer_x_max :float
    correct_answer_y_max :float

    timestamps
  end

  before_validation :check_labels

  validates :title, :presence => true
  validates :initial_prompt, :presence => true
  validates :give_up, :presence => true
  validates :confirm_correct, :presence => true

  def field_order
    "title, data_set, initial_prompt, answer_with_label, give_up, confirm_correct, correct_answer_x, correct_answer_y, correct_answer_x_min, correct_answer_y_min, correct_answer_x_max, correct_answer_y_max"
  end

  has_one :page_sequence, :as => :sequence, :dependent => :destroy

  has_one :page, :through => :page_sequence
  reverse_association_of :page, 'Page#pick_a_point_sequences'

  has_many :sequence_hints, :order => :position
  has_many :text_hints, :through => :sequence_hints, :source => :hint, :source_type => 'TextHint'
  reverse_association_of :text_hints, 'TextHint#pick_a_point_sequence'

  has_many :initial_prompt_prompts
  has_many :initial_range_visual_prompts, :through => :initial_prompt_prompts, :source => :prompt, :source_type => 'RangeVisualPrompt'
  reverse_association_of :initial_range_visual_prompts, 'RangeVisualPrompt#initial_prompt_sequence'

  has_many :initial_point_circle_visual_prompts, :through => :initial_prompt_prompts, :source => :prompt, :source_type => 'PointCircleVisualPrompt'
  reverse_association_of :initial_point_circle_visual_prompts, 'PointCircleVisualPrompt#initial_prompt_sequence'

  has_many :initial_point_axis_line_visual_prompts, :through => :initial_prompt_prompts, :source => :prompt, :source_type => 'PointAxisLineVisualPrompt'
  reverse_association_of :initial_point_axis_line_visual_prompts, 'PointAxisLineVisualPrompt#initial_prompt_sequence'

  has_many :give_up_prompts
  has_many :give_up_range_visual_prompts, :through => :give_up_prompts, :source => :prompt, :source_type => 'RangeVisualPrompt'
  reverse_association_of :give_up_range_visual_prompts, 'RangeVisualPrompt#give_up_sequence'

  has_many :give_up_point_circle_visual_prompts, :through => :give_up_prompts, :source => :prompt, :source_type => 'PointCircleVisualPrompt'
  reverse_association_of :give_up_point_circle_visual_prompts, 'PointCircleVisualPrompt#give_up_sequence'

  has_many :give_up_point_axis_line_visual_prompts, :through => :give_up_prompts, :source => :prompt, :source_type => 'PointAxisLineVisualPrompt'
  reverse_association_of :give_up_point_axis_line_visual_prompts, 'PointAxisLineVisualPrompt#give_up_sequence'

  has_many :confirm_correct_prompts
  has_many :confirm_range_visual_prompts, :through => :confirm_correct_prompts, :source => :prompt, :source_type => 'RangeVisualPrompt'
  reverse_association_of :confirm_range_visual_prompts, 'RangeVisualPrompt#confirm_correct_sequence'

  has_many :confirm_point_circle_visual_prompts, :through => :confirm_correct_prompts, :source => :prompt, :source_type => 'PointCircleVisualPrompt'
  reverse_association_of :confirm_point_circle_visual_prompts, 'PointCircleVisualPrompt#confirm_correct_sequence'

  has_many :confirm_point_axis_line_visual_prompts, :through => :confirm_correct_prompts, :source => :prompt, :source_type => 'PointAxisLineVisualPrompt'
  reverse_association_of :confirm_point_axis_line_visual_prompts, 'PointAxisLineVisualPrompt#confirm_correct_sequence'

  children :sequence_hints, :initial_prompt_prompts, :confirm_correct_prompts, :give_up_prompts

  belongs_to :data_set

  has_one :graph_label

  def to_hash
    ip_hash = {'text' => initial_prompt.to_s }
    if answer_with_label && graph_label
      ip_hash['label'] = graph_label.name
    end
    hash = {
      'type' => 'PickAPointSequence',
      'initialPrompt' => ip_hash,
      'giveUp' => {'text' => give_up.to_s },
      'confirmCorrect' => {'text' => confirm_correct.to_s },
    }
    hash['dataSetName'] = data_set_name if data_set_name
    if correct_answer_x && correct_answer_y
      hash['correctAnswerPoint'] = [correct_answer_x, correct_answer_y]
    elsif correct_answer_x_min || correct_answer_y_min || correct_answer_x_max || correct_answer_y_max
      hash['correctAnswerRange'] = {
        'xMin' => correct_answer_x_min,
        'yMin' => correct_answer_y_min,
        'xMax' => correct_answer_x_max,
        'yMax' => correct_answer_y_max
      }
    end
    update_sequence_prompts(hash)
    hash
  end

  def data_set_name_from_hash(definition)
    callback = Proc.new do
      self.reload
      found_data_set = self.page.activity.data_sets.find_by_name(definition)
      self.data_set = found_data_set
      self.save!
    end
    self.add_marshal_callback(callback)
  end

  def correct_answer_point_from_hash(definition)
    self.correct_answer_x = definition[0]
    self.correct_answer_y = definition[1]
  end

  def correct_answer_range_from_hash(definition)
    self.correct_answer_y_min = definition['yMin']
    self.correct_answer_x_min = definition['xMin']
    self.correct_answer_y_max = definition['yMax']
    self.correct_answer_x_max = definition['xMax']
  end

  protected
  def check_labels
    if answer_with_label && graph_label.blank?
      # The only attribute which should be significant (and included in the semantic JS) is the name. The rest should be (re) built by the runtime when the student adds their label.
      self.graph_label = GraphLabel.create(:name => "Label for #{initial_prompt.to_s}", :text => "Student label", :x_coord => 0, :y_coord => 0)
    end
  end
  def data_set_name
    return data_set.name if data_set
    return nil
  end
end
