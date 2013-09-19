class LabelSetGraphPane < ActiveRecord::Base

  hobo_model # Don't put anything above this

  include SgPermissions
  sg_parent :page

  fields do
    timestamps
  end

  belongs_to :label_set
  belongs_to :pane, :polymorphic => true

end
