require 'spec_helper'

describe ActivityFilter do

  before(:each) do
    @first_grade  = GradeLevel.create(:name => '1')
    @second_grade = GradeLevel.create(:name => '2')
    @math         = SubjectArea.create(:name => 'math')
    @science      = SubjectArea.create(:name => 'science')

    @private      = Activity.create(:name => 'private')
    @simple       = Activity.create(:name => 'simple', :publication_status =>'public')

    @first_grade_math  = Activity.create({
      :name => 'first grade math math activitiy', 
      :subject_areas => [@math], 
      :grade_levels =>[@first_grade],
      :publication_status =>'public'
    })
    @second_grade_math  = Activity.create(
      :name => 'second grade math activitiy', 
      :subject_areas      => [@math], 
      :grade_levels       => [@second_grade],
      :publication_status =>'public'
    )
    @first_grade_science  = Activity.create(
      :name => 'first grade science activitiy', 
      :subject_areas => [@science], :grade_levels =>[@first_grade],
      :publication_status =>'public'
    )

    @simple_science_and_math  = Activity.create(
      :name => 'simple first grade science and math activitiy', 
      :subject_areas => [@science,@math], :grade_levels =>[@first_grade],
      :publication_status =>'public'
    )
  end


  describe "activities" do
    describe "with no filtering" do
      
      it "should return all public activities" do
        params = {}
        ActivityFilter.new(Activity.publication_status_is('public'),params).activities.should =~ [
          @simple,
          @first_grade_math,
          @second_grade_math,
          @first_grade_science,
          @simple_science_and_math
        ]
      end
      # implicit: missing the private activity.
    end

    describe "searching by title only only" do
      it "should return activities with 'simple' in the name" do
        params = {'search' => 'simple'}
        ActivityFilter.new(Activity.publication_status_is('public'),params).activities.should =~[
          @simple,
          @simple_science_and_math
        ]
        #implicit: missing everything else.
      end
    end
    
    describe "searching for one grade level" do
      it "should return only first grade activities" do
        params = {'grade_levels' => @first_grade.id.to_s}
        ActivityFilter.new(Activity.publication_status_is('public'),params).activities.should =~[
          @first_grade_math,
          @first_grade_science,
          @simple_science_and_math
        ]
        #implicit: missing everything else.
      end
    end

    describe "searching for two grade levels" do
      it "should return activities in either grade level (1 & 2)" do
        params = {'grade_levels' => [@first_grade.id.to_s, @second_grade.id.to_s]}
        ActivityFilter.new(Activity.publication_status_is('public'),params).activities.should =~[
          @first_grade_math,
          @second_grade_math,
          @simple_science_and_math,
          @first_grade_science
        ]
        #implicit: missing everything else.
      end
    end

    describe "searching name and grade" do
      it "should return activities with 'simple' in the name" do
        params = {'grade_levels' => @first_grade.id.to_s, 'search' => 'simple'}
        ActivityFilter.new(Activity.publication_status_is('public'),params).activities.should =~[
          @simple_science_and_math
        ]
        #implicit: missing everything else.
      end
    end

    describe "with search string and subject_areas and grade_levels" do
      it "should return the only activity in first grade in math" do
        params = {'subject_areas' => [@math.id.to_s, @science.id.to_s] }
        ActivityFilter.new(Activity.publication_status_is('public'),params).activities.should =~[
          @simple_science_and_math,
          @first_grade_science,
          @first_grade_math,
          @second_grade_math
        ]
        #implicit: missing everything else.
      end
    end  
  end

end