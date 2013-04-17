class LineConstructionSequence < ActiveRecord::Base
  hobo_model # Don't put anything above this

  # TODO: We could have these be i18nized constants....
  def self.defaults
    @defaults ||= {
      'initial_prompt'        => "Construct a line with y-interept %s, with slope %s.",
      'confirm_correct'       => "That is correct.",
      'slope_incorrect'       => "Incorrect, your slope is wrong.",
      'y_intercept_incorrect' => "Incorrect, your y-intercept is wrong.",
      'all_incorrect'         => "Incorrect. Try again." ,
      'give_up'               => "The correct answer is shown."
    }
  end

  # standard owner and admin permissions
  # defined in models/standard_permissions.rb
  include SgPermissions
  include SgMarshal
  sg_parent :page

  fields do
    title                 :string, :default => "new line construction"
    slope                 :float,  :default => 1
    slope_tolerance       :float,  :default => 0.1
    y_intercept           :float,  :default => 0
    y_intercept_tolerance :float,  :default => 0.1
    max_attempts          :integer, :default => 3
    initial_prompt        :html  
    confirm_correct       :html  
    slope_incorrect       :html  
    y_intercept_incorrect :html  
    all_incorrect         :html
    give_up               :html
    timestamps
  end

  def field_order
    "title, data_set, slope, slope_tolerance, y_intercept, y_intercept_tolerance, max_attempts, initial_prompt, slope_incorrect, y_intercept_incorrect, all_incorrect, confirm_correct, give_up"
  end

  has_one :page_sequence, :as => :sequence, :dependent => :destroy
  has_one :page, :through => :page_sequence
  reverse_association_of :page, 'Page#line_construction_sequences'
  
  before_validation :default_text_values

  belongs_to :data_set
  
  validates :title,                 :presence => true
  validates :initial_prompt,        :presence => true
  validates :confirm_correct,       :presence => true
  validates :slope_incorrect,       :presence => true
  validates :y_intercept_incorrect, :presence => true
  validates :all_incorrect,         :presence => true

  validates :slope,                 :numericality => true
  validates :slope_tolerance,       :numericality => true
  validates :y_intercept,           :numericality => true
  validates :y_intercept_tolerance, :numericality => true
  validates :max_attempts, :numericality => true

  def to_hash
    {
        "type"                => type,
        "slope"               => slope,
        "slopeTolerance"      => slope_tolerance,
        "yIntercept"          => y_intercept,
        "yInterceptTolerance" => y_intercept_tolerance,
        "maxAttempts"         => max_attempts,
        "initialPrompt"       => sprintf(initial_prompt,y_intercept, slope),
        "confirmCorrect"      => confirm_correct,
        "slopeIncorrect"      => slope_incorrect,
        "yInterceptIncorrect" => y_intercept_incorrect,
        "allIncorrect"        => all_incorrect,
        "giveUp"              => give_up,
        'dataSetName'         => data_set ? data_set.name : nil
    }
  end

  def type
    "LineConstructionSequence"
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

  protected
  def default_text_values
    LineConstructionSequence.defaults.each_pair do |key,value|
      # self.attributes[key] ||= value
      self.send("#{key}=", value) if self.send(key).nil? || self.send(key).empty?
    end
  end  

end
