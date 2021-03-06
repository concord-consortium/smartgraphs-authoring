class LabelSetGraphPane < ActiveRecord::Base

  hobo_model # Don't put anything above this

  include SgPermissions
  sg_parent :pane

  def edit_permitted?(attribute)
    # The sg_permissions.rb version of this wants to check the owner of its Activity.
    # However, it checks before the join model is saved, so there is no sg_parent; neither
    # parent nor pane, as it happens, which means the sg_parent process hits a nil and
    # throws an exception. To which I say, holy cats, folks, it's just a join model.
    if pane.blank? && label_set.blank?
      return true
    else
      super(attribute)
    end
  end

  fields do
    timestamps
  end

  belongs_to :label_set
  belongs_to :pane, :polymorphic => true

end
