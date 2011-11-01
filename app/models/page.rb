class Page < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name :string
    text :text
    timestamps
  end

  belongs_to :activity

  has_many :page_panes, :order => :position
  has_many :image_panes, :through => :page_panes, :source => :pane, :source_type => 'ImagePane'

  children :page_panes

  acts_as_list

  class << self
    alias :orig_reverse_reflection :reverse_reflection

    def reverse_reflection(association)
      case association.to_sym
      when :image_panes
        ImagePane.reflections[:page]
      else
        self.orig_reverse_reflection(association)
      end
    end
  end

  def to_hash
    hash = {
      'type' => 'Page',
      'name' => name,
      'text' => text.to_s
    }
    unless page_panes.empty?
      hash['panes'] = page_panes.map do |page_pane|
        page_pane.pane.to_hash
      end
    end
    hash
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
