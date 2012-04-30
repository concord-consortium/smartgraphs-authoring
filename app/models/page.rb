class Page < ActiveRecord::Base

  hobo_model # Don't put anything above this
  
  # standard owner and admin permissions
  # defined in models/standard_permissions.rb
  include SgPermissions
  include SgMarshal
  sg_parent :activity

  fields do
    name :string
    text :text
    timestamps
  end

  belongs_to :activity

  has_many :page_panes, :order => :position

  has_many :image_panes, :through => :page_panes, :source => :pane, :source_type => 'ImagePane'
  reverse_association_of :image_panes, 'ImagePane#page'

  has_many :predefined_graph_panes, :through => :page_panes, :source => :pane, :source_type => 'PredefinedGraphPane'
  reverse_association_of :predefined_graph_panes, 'PredefinedGraphPane#page'

  has_many :sensor_graph_panes, :through => :page_panes, :source => :pane, :source_type => 'SensorGraphPane'
  reverse_association_of :sensor_graph_panes, 'SensorGraphPane#page'

  has_many :prediction_graph_panes, :through => :page_panes, :source => :pane, :source_type => 'PredictionGraphPane'
  reverse_association_of :prediction_graph_panes, 'PredictionGraphPane#page'

  has_many :table_panes, :through => :page_panes, :source => :pane, :source_type => 'TablePane'
  reverse_association_of :table_panes, 'TablePane#page'

  has_many :page_sequences

  has_many :instruction_sequences, :through => :page_sequences, :source => :sequence, :source_type => 'InstructionSequence'
  reverse_association_of :instruction_sequences, 'InstructionSequence#page'

  has_many :pick_a_point_sequences, :through => :page_sequences, :source => :sequence, :source_type => 'PickAPointSequence'
  reverse_association_of :pick_a_point_sequences, 'PickAPointSequence#page'

  has_many :numeric_sequences, :through => :page_sequences, :source => :sequence, :source_type => 'NumericSequence'
  reverse_association_of :numeric_sequences, 'NumericSequence#page'

  has_many :constructed_response_sequences, :through => :page_sequences, :source => :sequence, :source_type => 'ConstructedResponseSequence'
  reverse_association_of :constructed_response_sequences, 'ConstructedResponseSequence#page'

  has_many :multiple_choice_sequences, :through => :page_sequences, :source => :sequence, :source_type => 'MultipleChoiceSequence'
  reverse_association_of :multiple_choice_sequences, 'MultipleChoiceSequence#page'

  has_many :slope_tool_sequences, :through => :page_sequences, :source => :sequence, :source_type => 'SlopeToolSequence'
  reverse_association_of :slope_tool_sequences, 'SlopeToolSequence#page'

  children :page_sequences, :page_panes

  acts_as_list

  def to_hash
    hash = {
      'type' => 'Page',
      'name' => name,
      'text' => text.to_s
    }
    unless page_panes.empty?
      hash['panes'] = page_panes.map do |page_pane|
        page_pane.pane.to_hash
      end
    end
    unless page_sequences.empty?
      hash['sequence'] = page_sequences.first.sequence.to_hash
    end
    hash
  end

  # see SgMarshal
  def panes_from_hash(defs)
    defs.each do |definition|
      klass_name = definition['type']
      klass = klass_name.constantize
      method_name = klass_name.underscore.pluralize
      obj = klass.from_hash(definition)
      self.send(method_name) << obj
    end
  end
end
