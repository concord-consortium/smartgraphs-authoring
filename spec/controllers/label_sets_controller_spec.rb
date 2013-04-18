require 'spec_helper'

describe LabelSetsController do
  
  describe '#destroy' do
    it 'redirects to the parent activity' do
      pending "Hobo doesn't often test controllers (see link in spec) and this test has permissions issues"
      # https://groups.google.com/forum/?fromgroups=#!searchin/hobousers/rspec$20controller/hobousers/Alo390mdifc/6z5YAA1l7_UJ
      controller.stub(:acting_user, {:signed_up => true, :administrator? => true})
      activity = FactoryGirl.create(:activity_with_labelset)
      labelset = activity.label_sets.first
      # labelset.stub(:destroy_permitted?, true)
      post :destroy, :_method => 'delete', :id => labelset.id
      response.should redirect_to activity_path(activity)
    end
  end
end
