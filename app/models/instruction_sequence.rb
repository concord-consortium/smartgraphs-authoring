class InstructionSequence < ActiveRecord::Base

  hobo_model # Don't put anything above this

  # standard owner and admin permissions
  # defined in models/standard_permissions.rb
  include SgPermissions
  include SgMarshal
  sg_parent :page

  fields do
    title                 :string, :default => "new instruction sequence"
    text :raw_html
    timestamps
  end

  validates :text, :presence => true
  validates :title, :presence => true

  has_one :page_sequence, :as => :sequence, :dependent => :destroy

  has_one :page, :through => :page_sequence
  reverse_association_of :page, 'Page#instruction_sequences'

  def to_hash
    {
      'type' => 'InstructionSequence',
      'text' => text,
      'title' => title
    }
  end

  def name
    title
  end

end
