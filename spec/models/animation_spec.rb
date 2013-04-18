require 'spec_helper'

describe Animation do
  let (:activity) { FactoryGirl.create(:activity_with_animation) }
  let (:animation) { FactoryGirl.create(:animation) }

  describe 'validations' do
    it 'enforces unique naming of animations in the same activity' do
      animation2 = FactoryGirl.create(:animation)
      animation2.name = animation.name
      animation2.should_not be_valid
    end

    it 'does not enforce unique naming of animations in different activities' do
      animation2 = FactoryGirl.create(:animation)
      animation2.name = animation.name
      animation2.activity = activity
      animation2.should be_valid
    end

    it 'enforces a nonblank activity name' do
      animation.name = ""
      animation.should_not be_valid
    end
  end

  describe '#sg_parent' do
    it 'returns the parent activity' do
      activity.animations.first.sg_parent.should == activity
    end
  end

  describe '#to_hash' do
    it 'returns the expected hash' do
      animation = activity.animations.first
      animation.to_hash.should == {
        'name' => animation.name,
        'dataset' => animation.data_set.name,
        'yMin' => animation.y_min,
        'yMax' => animation.y_max,
        'markedCoordinates' => animation.animation_marked_coordinates.map { |mc| mc.coordinate }
      }
    end
  end

  describe '#marked_coordinates_from_hash' do
    it 'creates and associates AnimationMarkedCoordinates from the coordinates array in the hash' do
      marked_coordinates = animation.marked_coordinates_from_hash([2,3])
      marked_coordinates.length.should eq 2
      marked_coordinates[0].coordinate.should eq 2
      marked_coordinates[1].coordinate.should eq 3
    end
  end

  describe 'copying an activity containing an animation' do
    it 'should be possible to copy an activity with an animation having a dataset and marked coordinates' do
      copy = activity.copy_activity()

      animation_copy = copy.animations.first
      animation_original = activity.animations.first

      animation_copy.should_not be_nil
      animation_copy.should_not eq animation_original

      animation_copy.data_set.should eq copy.data_sets.first
      animation_copy.animation_marked_coordinates.length.should eq 2
      animation_copy.animation_marked_coordinates[0].coordinate.should eq animation_original.animation_marked_coordinates[0].coordinate
      animation_copy.animation_marked_coordinates[1].coordinate.should eq animation_original.animation_marked_coordinates[1].coordinate
    end

    it 'should be possible to copy an activity with an animation having no dataset' do
      activity.data_sets = []

      copy = activity.copy_activity()
      animation_copy = copy.animations.first
      animation_original = activity.animations.first

      animation_copy.animation_marked_coordinates[0].coordinate.should eq animation_original.animation_marked_coordinates[0].coordinate
      animation_copy.animation_marked_coordinates[1].coordinate.should eq animation_original.animation_marked_coordinates[1].coordinate
    end

    it 'should be possible to copy an activity with an animation having no marked coordinates' do
      activity.animations.first.animation_marked_coordinates = []

      copy = activity.copy_activity()
      animation_copy = copy.animations.first
      animation_original = activity.animations.first

      animation_copy.data_set.should eq copy.data_sets.first
      animation_copy.animation_marked_coordinates.should be_empty
    end

  end

end
