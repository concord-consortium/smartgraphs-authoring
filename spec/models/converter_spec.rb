require 'spec_helper'

describe Converter do
  let(:process)   { '/bin/cat' }
  let(:converter) { Converter.new(process) }
  let(:input)     { 'testing 1 2 3' }
  subject         { converter.convert(input)}
  
  describe "convert with cat" do
    its(:output){ should == input }
  end

  describe "with broken converter" do
    let(:process) { '/bin/globdsdf'  } 
    its(:error)   { should be_kind_of(StandardError) }
    it "just messing" do
      puts subject.error_msg
    end
  end
  describe "with bad input" do
    # use the real default process
    let(:converter) { Converter.new() }
    its(:error)   { should be_kind_of(StandardError) }
    it "just messing" do
      puts subject.error_msg
    end
  end
end

