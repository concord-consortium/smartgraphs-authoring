class ImagePane < ActiveRecord::Base

  hobo_model # Don't put anything above this
  
  # standard owner and admin permissions
  # defined in models/standard_permissions.rb
  include StandardPermissions

  fields do
    name :string
    url :string
    license :string
    attribution :string
    timestamps
  end

  has_one :page_pane, :as => :pane, :dependent => :destroy
  has_one :page, :through => :page_pane

  reverse_association_of :page, 'Page#image_panes'

  def to_hash
    {
      'type' => 'ImagePane',
      'name' => name,
      'url' => url,
      'license' => license,
      'attribution' => attribution
    }
  end



end
