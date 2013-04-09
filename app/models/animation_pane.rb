class AnimationPane < ActiveRecord::Base

  hobo_model # Don't put anything above this

  include SgPermissions
  sg_parent :page

  fields do
    timestamps
  end

  belongs_to :animation

  has_one :page_pane, :as => :pane, :dependent => :destroy
  has_one :page, :through => :page_pane

  reverse_association_of :page, 'Page#animation_panes'

end
