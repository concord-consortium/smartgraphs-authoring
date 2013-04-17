class MultipleChoiceSequence < ActiveRecord::Base

  hobo_model # Don't put anything above this
  
  # standard owner and admin permissions
  # defined in models/standard_permissions.rb
  include SgPermissions
  include SgMarshal
  include SgSequencePrompts
  sg_parent :page
  
  fields do
    initial_prompt :html
    give_up :html
    confirm_correct :html
    use_sequential_feedback :boolean, :default => true
    timestamps
  end

  def field_order
    "data_set, initial_prompt, give_up, confirm_correct, use_sequential_feedback"
  end

  has_one :page_sequence, :as => :sequence, :dependent => :destroy

  has_one :page, :through => :page_sequence
  reverse_association_of :page, 'Page#multiple_choice_sequences'
  
  has_many :multiple_choice_choices, :dependent => :destroy, :order => :position

  has_many :multiple_choice_hints, :dependent => :destroy, :order => :position

  has_many :initial_prompt_prompts
  has_many :initial_range_visual_prompts, :through => :initial_prompt_prompts, :source => :prompt, :source_type => 'RangeVisualPrompt'
  reverse_association_of :initial_range_visual_prompts, 'RangeVisualPrompt#initial_prompt_multiple_choice_sequence'

  has_many :initial_point_circle_visual_prompts, :through => :initial_prompt_prompts, :source => :prompt, :source_type => 'PointCircleVisualPrompt'
  reverse_association_of :initial_point_circle_visual_prompts, 'PointCircleVisualPrompt#initial_prompt_multiple_choice_sequence'

  has_many :initial_point_axis_line_visual_prompts, :through => :initial_prompt_prompts, :source => :prompt, :source_type => 'PointAxisLineVisualPrompt'
  reverse_association_of :initial_point_axis_line_visual_prompts, 'PointAxisLineVisualPrompt#initial_prompt_multiple_choice_sequence'

  has_many :give_up_prompts
  has_many :give_up_range_visual_prompts, :through => :give_up_prompts, :source => :prompt, :source_type => 'RangeVisualPrompt'
  reverse_association_of :give_up_range_visual_prompts, 'RangeVisualPrompt#give_up_multiple_choice_sequence'

  has_many :give_up_point_circle_visual_prompts, :through => :give_up_prompts, :source => :prompt, :source_type => 'PointCircleVisualPrompt'
  reverse_association_of :give_up_point_circle_visual_prompts, 'PointCircleVisualPrompt#give_up_multiple_choice_sequence'

  has_many :give_up_point_axis_line_visual_prompts, :through => :give_up_prompts, :source => :prompt, :source_type => 'PointAxisLineVisualPrompt'
  reverse_association_of :give_up_point_axis_line_visual_prompts, 'PointAxisLineVisualPrompt#give_up_multiple_choice_sequence'

  has_many :confirm_correct_prompts
  has_many :confirm_range_visual_prompts, :through => :confirm_correct_prompts, :source => :prompt, :source_type => 'RangeVisualPrompt'
  reverse_association_of :confirm_range_visual_prompts, 'RangeVisualPrompt#confirm_correct_multiple_choice_sequence'

  has_many :confirm_point_circle_visual_prompts, :through => :confirm_correct_prompts, :source => :prompt, :source_type => 'PointCircleVisualPrompt'
  reverse_association_of :confirm_point_circle_visual_prompts, 'PointCircleVisualPrompt#confirm_correct_multiple_choice_sequence'

  has_many :confirm_point_axis_line_visual_prompts, :through => :confirm_correct_prompts, :source => :prompt, :source_type => 'PointAxisLineVisualPrompt'
  reverse_association_of :confirm_point_axis_line_visual_prompts, 'PointAxisLineVisualPrompt#confirm_correct_multiple_choice_sequence'

  children :multiple_choice_choices, :multiple_choice_hints, :initial_prompt_prompts, :give_up_prompts, :confirm_correct_prompts
  #children  :multiple_choice_hints, :multiple_choice_choices

  belongs_to :data_set

  def to_hash
    hash = {
      'type' => type,
      'initialPrompt' => { 'text' => initial_prompt.to_s },
      'choices' => multiple_choice_choices.map { |c| c.to_hash },
      'correctAnswerIndex' => correct_answer_index,
      'giveUp' => { 'text' => give_up.to_s },
      'confirmCorrect' => { 'text' => confirm_correct.to_s },
      'hints' => hints,
      'dataSetName'         => data_set ? data_set.name : ''
    }
    update_sequence_prompts(hash)
    hash
  end

  def type
    if use_sequential_feedback then
      'MultipleChoiceWithSequentialHintsSequence'
    else
      'MultipleChoiceWithCustomHintsSequence'
    end
  end
  
  def hints
    if use_sequential_feedback
      return multiple_choice_hints.map { |h| h.to_hash   }
    end
    multiple_choice_choices.map { |c| c.hint_hash }
  end

  # return the first correct answer
  def correct_answer
    multiple_choice_choices.detect { |a| a.correct }
  end

  def correct_answer_index
    if correct_answer
      return correct_answer.position - 1
    end
    # TODO: What do we do? Its an error condition right?
  end

  def has_correct_answer?
    return !correct_answer.nil?
  end

  def choices_from_hash(definition)
    definition.each do |d|
      self.multiple_choice_choices << MultipleChoiceChoice.from_hash({'name' => d},self.marshal_context)
      # later we are going to have to add references to these choices
      # for correct item number &etc.
    end
    if @pending_callbacks
      @pending_callbacks.each do |callback|
        callback.call(self)
      end
    end
  end

  def hints_from_hash(definition)
    if use_sequential_feedback
      definition.each do |d|
        self.multiple_choice_hints << MultipleChoiceHint.from_hash(d,self.marshal_context)
      end
    else
      @pending_callbacks ||= []
      callback = Proc.new do |self_ref|
        definition.each_with_index do |d,i|
          self_ref.multiple_choice_choices[i].feedback = d['text'];
        end
      end
      if self.multiple_choice_choices && self.multiple_choice_choices.size > 0
        callback.call(self)
      else
        @pending_callbacks << callback
      end
    end
  end

  def correct_answer_index_from_hash(index)
    @pending_callbacks ||= []
    callback = Proc.new do |self_ref|
      self_ref.multiple_choice_choices.each { |c| c.correct = false}
      self_ref.multiple_choice_choices[index].correct = true;
    end
    if self.multiple_choice_choices && self.multiple_choice_choices.size > index
      callback.call(self)
    else
      @pending_callbacks << callback
    end
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
end
