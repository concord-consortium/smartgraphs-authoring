class LineConstructionSequence < ActiveRecord::Base
  hobo_model # Don't put anything above this

  # TODO: We could have these be i18nized constants....
  def self.defaults
    @defaults ||= {
      'initial_prompt'        => "Construct a line with y-interept %s, with slope %s.",
      'confirm_correct'       => "That is Correct.",
      'slope_incorrect'       => "Incorrect, your slope is wrong.",
      'y_intercept_incorrect' => "Incorrect, your y-intercept is wrong.",
      'all_incorrect'         => "Incorrect. Try again." 
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
    initial_prompt        :text  
    confirm_correct       :text  
    slope_incorrect       :text  
    y_intercept_incorrect :text  
    all_incorrect         :text  
    timestamps
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

  def to_hash
    {
        "type"                => type,
        "slope"               => slope,
        "slopeTolerance"      => slope_tolerance,
        "yIntercept"          => y_intercept,
        "yInterceptTolerance" => y_intercept_tolerance,
        "initialPrompt"       => sprintf(initial_prompt,y_intercept, slope),
        "confirmCorrect"      => confirm_correct,
        "slopeIncorrect"      => slope_incorrect,
        "yInterceptIncorrect" => y_intercept_incorrect,
        "allIncorrect"        => all_incorrect,
        'dataSetName'         => data_set.name
    }
  end

  def type
    "LineConstructionSequence"
  end

  protected
  def default_text_values
    LineConstructionSequence.defaults.each_pair do |key,value|
      # self.attributes[key] ||= value
      self.send("#{key}=", value) if self.send(key).nil? || self.send(key).empty?
    end
  end  

end
