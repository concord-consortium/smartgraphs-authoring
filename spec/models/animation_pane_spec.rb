require 'spec_helper'

describe AnimationPane do
  let (:activity) { FactoryGirl.create(:activity_with_animation_pane) }

  let (:data_set_expression) do 
    ds = FactoryGirl.create(:data_set)
    ds.expression = 'y=x+1'
    ds.save
    ds
  end

  let (:data_set_points) do
    ds = FactoryGirl.create(:data_set)
    ds.data = "2,2\n3,3\n1,1\n5,5\n4,4"
    ds.save
    ds
  end

  describe '#sg_parent' do
    it 'returns the parent page' do
      page = activity.pages.first
      page.animation_panes.first.sg_parent.should == page
    end
  end

  context 'when data_set is an expression' do
    before(:each) do
      activity.pages.first.animation_panes.first.animation.data_set = data_set_expression
      activity.pages.first.animation_panes.first.animation.save
    end

    describe '#calc_range' do
      it 'returns nil' do
        activity.pages.first.animation_panes.first.calc_range.should be_nil
      end
    end

    describe '#has_x_range?' do
      it 'returns false' do
        activity.pages.first.animation_panes.first.has_x_range?.should be_false
      end
    end

    describe '#needs_x_range?' do
      it 'returns true' do
        activity.pages.first.animation_panes.first.needs_x_range?.should be_true
      end
    end
  end

  context 'when data_set is a set of points' do
    before(:each) do
      activity.pages.first.animation_panes.first.animation.data_set = data_set_points
      activity.pages.first.animation_panes.first.animation.save
    end

    describe '#calc_range' do
      it 'returns the min x value of the data_set if the data is points' do
        activity.pages.first.animation_panes.first.calc_range[:min].should == 1.0
      end

      it 'returns the max x value of the data_set if the data is points' do
        activity.pages.first.animation_panes.first.calc_range[:max].should == 5.0
      end
    end

    describe '#has_x_range?' do
      it 'returns true' do
        activity.pages.first.animation_panes.first.has_x_range?.should be_true
      end
    end

    describe '#needs_x_range?' do
      it 'returns false' do
        activity.pages.first.animation_panes.first.needs_x_range?.should be_false
      end
    end
  end

  describe '#to_hash' do
    it 'returns the expected hash' do
      pane = activity.pages.first.animation_panes.first
      animation = pane.animation
      animation.data_set = data_set_points

      pane.to_hash.should == {
        'type' => 'AnimationPane',
        'animation' => animation.name,
        'xMin' => 1.0,
        'xMax' => 5.0
      }
    end
  end

  describe 'copying an activity containing an animation pane' do
    it 'should be possible to copy an activity with an animation pane' do
      activity.pages.first.animation_panes.first.animation.data_set = data_set_points
      activity.pages.first.animation_panes.first.animation.save
      copy = activity.copy_activity()

      pane = copy.pages.first.animation_panes.first
      animation = copy.animations.first

      pane.animation.should eq animation
    end
  end
end
