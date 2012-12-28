class TablePane < ActiveRecord::Base

  hobo_model # Don't put anything above this

  # standard owner and admin permissions
  # defined in models/standard_permissions.rb
  include SgPermissions
  include SgMarshal
  sg_parent :page
  
  fields do
    title :string
    x_label :string
    y_label :string
    timestamps
  end

  has_one :page_pane, :as => :pane, :dependent => :destroy
  has_one :page, :through => :page_pane

  reverse_association_of :page, 'Page#table_panes'

  def to_hash
    {
      'type' => 'TablePane',
      'xLabel' => x_label.blank? ? '' : x_label,
      'yLabel' => y_label.blank? ? '' : y_label,
      'title' => title
    }
  end

end
