class BestFitSequence < ActiveRecord::Base

  hobo_model # Don't put anything above this

  # Note: BestFitSequences use a PredefinedGraphPane, not a PredictionGraphPane
  # Note: the data_set needs more than 5 points

  # TODO: We could have these be i18nized constants....
  def self.defaults
    @defaults ||= {
      'initial_prompt'        => "Find the line of best fit for this scatter plot.",
      'confirm_correct'       => "You made an excellent estimate.",
      'close_prompt'          => "Your estimate is close; try again.",
      'incorrect_prompt'      => "Your estimate can be better; try again.",
    }
  end

  # standard owner and admin permissions
  # defined in models/standard_permissions.rb
  include SgPermissions
  include SgMarshal
  sg_parent :page
  
  fields do
    correct_tolerance :float, :default => 0.1
    close_tolerance :float, :default => 0.2
    max_attempts :integer, :default => 4
    initial_prompt :text
    incorrect_prompt :text
    close_prompt :text
    confirm_correct :text
    timestamps
  end

  def field_order
  end

  has_one :page_sequence, :as => :sequence, :dependent => :destroy

  has_one :page, :through => :page_sequence
  reverse_association_of :page, 'Page#best_fit_sequences'

  belongs_to :data_set
  belongs_to :learner_data_set, :class_name => 'DataSet'

  before_validation :default_text_values

  def to_hash
    {
      'type'                => type,
      'dataSetName'         => data_set ? data_set.name : '',
      'learnerDataSet'      => learner_data_set ? learner_data_set.name : '',
      'correctTolerance'    => correct_tolerance,
      'closeTolerance'      => close_tolerance,
      'initialPrompt'       => initial_prompt,
      'incorrectPrompt'     => incorrect_prompt,
      'closePrompt'         => close_prompt,
      'confirmCorrect'      => confirm_correct,
      'maxAttempts'         => max_attempts
    }
  end

  def type
    "BestFitSequence"
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

  def learner_data_set_from_hash(definition)
    callback = Proc.new do
      self.reload
      found_data_set = self.page.activity.data_sets.find_by_name(definition)
      self.learner_data_set = found_data_set
      self.save!
    end
    self.add_marshall_callback(callback)
  end

  protected
  def default_text_values
    BestFitSequence.defaults.each_pair do |key,value|
      # self.attributes[key] ||= value
      self.send("#{key}=", value) if self.send(key).nil? || self.send(key).empty?
    end
  end  
end
