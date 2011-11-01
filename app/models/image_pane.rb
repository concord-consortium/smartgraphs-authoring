class ImagePane < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name :string
    url :string
    license :string
    attribution :string
    timestamps
  end

  has_one :page_pane, :as => :pane, :dependent => :destroy
  has_one :page, :through => :page_pane

  class << self
    alias :orig_reverse_reflection :reverse_reflection

    def reverse_reflection(association)
      case association.to_sym
      when :page
        Page.reflections[:image_panes]
      else
        self.orig_reverse_reflection(association)
      end
    end
  end

  def to_hash
    {
      'type' => 'ImagePane',
      'name' => name,
      'url' => url,
      'license' => license,
      'attribution' => attribution
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
