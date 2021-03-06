class EmptyPane < ActiveRecord::Base

  hobo_model # Don't put anything above this

  include SgPermissions
  include SgMarshal
  sg_parent :page

  fields do
    timestamps
  end

  has_one :page_pane, :as => :pane, :dependent => :destroy
  has_one :page, :through => :page_pane

  reverse_association_of :page, 'Page#empty_panes'

  def to_hash
    {
      'type' => 'EmptyPane'
    }
  end

end
