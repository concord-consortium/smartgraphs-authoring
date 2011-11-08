class Page < ActiveRecord::Base

  hobo_model # Don't put anything above this

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

  has_many :table_panes, :through => :page_panes, :source => :pane, :source_type => 'TablePane'
  reverse_association_of :table_panes, 'TablePane#page'

  has_many :page_sequences

  has_many :instruction_sequences, :through => :page_sequences, :source => :sequence, :source_type => 'InstructionSequence'
  reverse_association_of :instruction_sequences, 'InstructionSequence#page'

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
