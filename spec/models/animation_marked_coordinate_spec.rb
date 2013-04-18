require 'spec_helper'

  describe AnimationMarkedCoordinate do

    let (:animation) { FactoryGirl.create(:animation_with_marked_coordinates) }

    it 'validates presence of coordinate' do
      AnimationMarkedCoordinate.new.should_not be_valid
      AnimationMarkedCoordinate.new(:coordinate => 0).should be_valid
    end

  describe '#sg_parent' do
    it 'should return the parent Animation' do
      animation.animation_marked_coordinates.first.sg_parent.should be animation
    end
  end

end
