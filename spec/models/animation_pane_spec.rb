require 'spec_helper'

describe AnimationPane do
  let (:activity) { FactoryGirl.create(:activity_with_animation_pane) }

  describe '#sg_parent' do
    it 'returns the parent page' do
      page = activity.pages.first
      page.animation_panes.first.sg_parent.should == page
    end
  end

  describe '#to_hash' do
    it 'returns the expected hash' do
      pane = activity.pages.first.animation_panes.first
      animation = pane.animation

      pane.to_hash.should == {
        'type' => 'AnimationPane',
        'animation' => animation.name
      }
    end
  end

  describe 'copying an activity containing an animation pane' do
    it 'should be possible to copy an activity with an animation pane' do
      copy = activity.copy_activity()

      pane = copy.pages.first.animation_panes.first
      animation = copy.animations.first

      pane.animation.should eq animation
    end
  end
end
