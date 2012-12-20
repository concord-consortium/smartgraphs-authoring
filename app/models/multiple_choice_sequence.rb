class MultipleChoiceSequence < ActiveRecord::Base

  hobo_model # Don't put anything above this
  
  # standard owner and admin permissions
  # defined in models/standard_permissions.rb
  include SgPermissions
  include SgMarshal
  sg_parent :page
  
  fields do
    initial_prompt :text
    give_up :text
    confirm_correct :text
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

  children :multiple_choice_choices, :multiple_choice_hints
  #children  :multiple_choice_hints, :multiple_choice_choices

  belongs_to :data_set

  def to_hash
    {
      'type' => type,
      'initialPrompt' => initial_prompt,
      'choices' => multiple_choice_choices.map { |c| c.to_hash },
      'correctAnswerIndex' => correct_answer_index,
      'giveUp' => give_up,
      'confirmCorrect' => confirm_correct,
      'hints' => hints,
      'dataSetName'         => data_set ? data_set.name : ''
    }
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
    self.add_marshall_callback(callback)
  end
end
