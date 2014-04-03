require 'spec_helper'

describe EmptyPane do
  describe '#sg_parent' do
    it 'returns the parent page' do
      page = Page.create(:name => 'Dummy Page')
      page.empty_panes = [EmptyPane.create]
      page.empty_panes.first.reload.sg_parent.should == page
    end
  end

  describe '#to_hash' do
    it 'returns the expected hash' do
      pane = EmptyPane.create

      pane.to_hash.should == {
        'type' => 'EmptyPane'
      }
    end
  end
end
