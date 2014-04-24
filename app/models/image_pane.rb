class ImagePane < ActiveRecord::Base

  hobo_model # Don't put anything above this
  
  # standard owner and admin permissions
  # defined in models/standard_permissions.rb
  include SgPermissions
  include SgMarshal
  sg_parent :page
  
  fields do
    name :string
    url :string
    license :string
    attribution :string
    show_full_image :boolean
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
      'attribution' => attribution,
      'show_full_image' => show_full_image
    }
  end



end
