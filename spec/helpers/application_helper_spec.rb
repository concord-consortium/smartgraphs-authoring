require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the ApplicationHelper. For example:
#
# describe ApplicationHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe ApplicationHelper do
  describe 'activity_for' do
    before(:all) do
      @act = Activity.create!(:name => 'Activity to be found')
      @page = Page.create!(:name => "Dummy Page")
      @page.activity = @act
      @page.save
    end

    it 'returns an activity if there is a page_id' do
      pending "This can't be effectively tested until I can supply params the helper can read"
      controller.request = ActionController::TestRequest.new(:params => { :page_id => @page.id })
      pp = PickAPointSequence.new()
      helper.activity_for(pp).should == @act
    end

    it 'returns an activity if there is an activity_id' do
      pending "This can't be effectively tested until I can supply params the helper can read"
      controller.request = ActionController::TestRequest.new(:params => { :activity_id => @act.id })
      pp = PickAPointSequence.new()
      helper.activity_for(pp).should == @act
    end

    it 'returns an activity if the supplied argument responds to activity' do
      pp = PickAPointSequence.new()
      pp.page = @page
      helper.activity_for(pp).should == @act
    end

    it 'returns nil if it has no way to find an activity' do
      stub = Object.new()
      helper.activity_for(pp).should === nil
    end
  end
end
