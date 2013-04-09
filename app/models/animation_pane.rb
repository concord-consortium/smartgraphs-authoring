class AnimationPane < ActiveRecord::Base

  hobo_model # Don't put anything above this

  include SgPermissions
  include SgMarshal
  sg_parent :page

  fields do
    timestamps
  end

  belongs_to :animation

  has_one :page_pane, :as => :pane, :dependent => :destroy
  has_one :page, :through => :page_pane

  reverse_association_of :page, 'Page#animation_panes'

  def to_hash
    {
      'type' => 'AnimationPane',
      'animation' => animation && animation.name || ""
    }
  end

  def animation_from_hash(definition)
    return if definition.length == 0
    callback = Proc.new do
      self.reload
      self.animation = self.page.activity.animations.find_by_name(definition)
      self.save!
    end
    self.add_marshal_callback(callback)
  end

end
