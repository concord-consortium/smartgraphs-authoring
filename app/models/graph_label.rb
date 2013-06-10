class GraphLabel < ActiveRecord::Base

  hobo_model # Don't put anything above this
  include SgMarshal
  include SgPermissions
  sg_parent :label_set

  belongs_to :label_set

  belongs_to :pick_a_point_sequence
  belongs_to :predefined_graph_pane

  scope :no_label_set, where(:label_set_id => nil)

  fields do
    text :string, :required => true
    name :string, :required => false
    x_coord :float, :required => true
    y_coord :float, :required => true
    timestamps
  end

  def self.for_activity(activity)
    if activity.blank?
      nil
    else
      activity.labels
    end
  end

  def self.free_for_activity(activity)
    if activity.blank?
      nil
    else
      activity.free_labels
    end
  end

  def field_order
    "name, text, x_coord, y_coord"
  end

  def to_hash
    label = {
      'text' => text,
      'x_coord' => x_coord,
      'y_coord' => y_coord
    }
    label['name'] = name unless name.blank?
    label
  end
end
