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

  # Set values for x_label and y_label by copying them from a graph pane on the same page.
  def get_labels_from_graph_pane
    page = self.page
    if page # Ignore orphaned panes
      graph_panes = [page.predefined_graph_panes + page.prediction_graph_panes + page.sensor_graph_panes].flatten
      graph_panes.each do |gp|
        # We're trusting here that there won't be more than one graph pane.
        # If there are, and the last one has labels, we'll get that one's labels.
        # But it's at least possible that we could get labels from two different graph panes.
        if gp.x_label || gp.y_label
          self.x_label = gp.x_label
          self.y_label = gp.y_label
          self.save!
        end
      end
    end
  end

  def self.get_all_labels_from_graph_panes
    TablePane.all.each do |tp|
      tp.get_labels_from_graph_pane
    end
  end
end
