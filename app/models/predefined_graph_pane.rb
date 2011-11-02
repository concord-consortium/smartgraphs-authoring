class PredefinedGraphPane < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    title :string
    y_label :string
    # need to add y units
    y_min :float
    y_max :float
    y_ticks :float
    x_label :string
    # need to add x units
    x_min :float
    x_max :float
    x_ticks :float
    timestamps
  end

  belongs_to :y_unit, :class_name => 'Unit'
  belongs_to :x_unit, :class_name => 'Unit'

  has_one :page_pane, :as => :pane, :dependent => :destroy
  has_one :page, :through => :page_pane

  class << self
    alias :orig_reverse_reflection :reverse_reflection

    def reverse_reflection(association)
      case association.to_sym
      when :page
        Page.reflections[:predefined_graph_panes]
      else
        self.orig_reverse_reflection(association)
      end
    end
  end

  def to_hash
    {
      'type' => 'PredefinedGraphPane',
      'title' => title,
      'yLabel' => y_label,
      'yMin' => y_min,
      'yMax' => y_max,
      'xLabel' => x_label,
      'xMin' => x_min,
      'xMax' => x_max
    }
  end

  # --- Permissions --- #

  def create_permitted?
    acting_user.administrator?
  end

  def update_permitted?
    acting_user.administrator?
  end

  def destroy_permitted?
    acting_user.administrator?
  end

  def view_permitted?(field)
    true
  end

end
