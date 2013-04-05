class Animation < ActiveRecord::Base

  hobo_model # Don't put anything above this

  include SgMarshal
  include SgPermissions
  sg_parent :activity

  fields do
    name  :string, :required => true
    y_min :float, :required => true
    y_max :float, :required => true
    timestamps
  end

  belongs_to :activity
  # not marked as required so that a user can choose to create an animation, *then* its data set
  belongs_to :data_set
  has_many :animation_marked_coordinates, :dependent => :destroy, :accessible => true

  validates :name, :uniqueness => {
    :scope => :activity_id,
    :message => "is already used elsewhere in the activity"
  }
  validates :name, :length => { :minimum => 1 }

  def field_order
    "name, data_set, y_min, y_max"
  end

  def to_hash
    {
      "name" => name,
      "yMin" => y_min,
      "yMax" => y_max,
      "markedCoordinates" => animation_marked_coordinates.map(&:coordinate),
      "dataset" => data_set.name
    }
  end

  def marked_coordinates_from_hash(definitions)
    self.animation_marked_coordinates = definitions.map do |d|
      AnimationMarkedCoordinate.new :coordinate => d
    end
  end

  def dataset_from_hash(definition)
    callback = Proc.new do
      self.reload
      self.data_set = self.activity.data_sets.find_by_name(definition)
      self.save!
    end
    self.add_marshal_callback(callback)
  end

end
