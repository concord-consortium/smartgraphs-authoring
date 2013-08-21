class AnimationPane < ActiveRecord::Base

  hobo_model # Don't put anything above this

  include SgPermissions
  include SgMarshal
  sg_parent :page

  fields do
    spec_min_x :float
    spec_max_x :float
    timestamps
  end

  belongs_to :animation

  has_one :page_pane, :as => :pane, :dependent => :destroy
  has_one :page, :through => :page_pane

  reverse_association_of :page, 'Page#animation_panes'

  def to_hash
    {
      'type' => 'AnimationPane',
      'animation' => animation && animation.name || "",
      'xMin' => calc_min_x ? calc_min_x : spec_min_x,
      'xMax' => calc_max_x ? calc_max_x : spec_max_x
    }
  end

  def x_min_from_hash(definition)
    self.spec_min_x = definition
    # TODO: Should we zero this if calc_min_x returns a value?
  end

  def x_max_from_hash(definition)
    self.spec_max_x = definition
    # TODO: Should we zero this if calc_min_x returns a value?
  end

  # If we can get x-min and x-max from the animation's dataset, we should.
  # However, if it's an expression, we can't, and we need to ask the author
  # for those values. These methods try to get the values from the animation's
  # dataset, and return nil if it's an expression.
  def calc_min_x
    if animation.data_set.expression.blank?
      # x-min is the first value of the point which is first in the order when the points are sorted.
      return animation.data_set.data_to_hash.sort.first[0]
    else
      # The data set is defined by an expression, so we need a starting and ending point.
      return nil
    end
  end

  def calc_max_x
    if animation.data_set.expression.blank?
      # x-max is the first value of the point which is last in the order when the points are sorted.
      return animation.data_set.data_to_hash.sort.last[0]
    else
      # The data set is defined by an expression, so we need a starting and ending point.
      return nil
    end
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
