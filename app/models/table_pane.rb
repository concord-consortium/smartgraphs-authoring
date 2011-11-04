class TablePane < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    title :string
    timestamps
  end

  has_one :page_pane, :as => :pane
  has_one :page, :through => :page_pane


  class << self
    alias :orig_reverse_reflection :reverse_reflection

    def reverse_reflection(association)
      case association.to_sym
      when :page
        Page.reflections[:table_panes]
      else
        self.orig_reverse_reflection(association)
      end
    end
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
