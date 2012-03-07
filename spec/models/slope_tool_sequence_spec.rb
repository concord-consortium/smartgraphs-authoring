require 'spec_helper'

describe SlopeToolSequence do
  describe "case_type field validation" do
    it "should require case_type to be one of A B or C" do
      slope_tool = SlopeToolSequence.new(:case_type => :case_b)
      slope_tool.should be_valid
      slope_tool = SlopeToolSequence.new(:case_type => true)
      slope_tool.errors.should_not be_nil
    end
  end
  describe "first_question_is_slope_question" do
    it "should return true for cases A and C" do
      slope_tool = SlopeToolSequence.new(:case_type => :case_a)
      slope_tool.first_question_is_slope_question.should == true
      slope_tool = SlopeToolSequence.new(:case_type => :case_c)
      slope_tool.first_question_is_slope_question.should == true
    end
    it "should return false for case B" do
      slope_tool = SlopeToolSequence.new(:case_type => :case_b)
      slope_tool.first_question_is_slope_question.should == false
    end
  end
  describe "student_selects_points" do
    it "should return true for cases A and B" do
      slope_tool = SlopeToolSequence.new(:case_type => :case_a)
      slope_tool.student_selects_points.should == true
      slope_tool = SlopeToolSequence.new(:case_type => :case_b)
      slope_tool.student_selects_points.should == true
    end
    it "should return false for case C" do
      slope_tool = SlopeToolSequence.new(:case_type => :case_c)
      slope_tool.student_selects_points.should == false
    end
  end
end
