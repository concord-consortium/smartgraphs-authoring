require 'spec_helper'
require_relative 'dummy_marshal.rb'

describe SgMarshal do

  let(:input_hash) { { 'attr1_key' => "attr1_value", 'attr2_key' => "attr2_value", 'Attr3Key' => "Attr3Value", 'attr4_key' => ["attr4_value"], 'attr5_key' => {'text' => "some Text" }, "attr6_key" => {:my_key => "my Value"}}}

  let(:underscored_hash) {  {"attr1_key"=>"attr1_value", "attr2_key"=>"attr2_value", "attr3_key"=>"Attr3Value", "attr4_key"=>["attr4_value"], "attr5_key"=>{"text"=>"some Text"}, "attr6_key"=>{:my_key=>"my Value"}} }

  describe ".filter_attributes" do

    it "should underscore keys" do
      u_hash = Hash[input_hash.map {|k,v| [k.underscore, v]}]
      u_hash['attr1_key'].should == 'attr1_value'
      u_hash['attr2_key'].should == 'attr2_value'
      u_hash['attr3_key'].should == 'Attr3Value'    
      u_hash['attr4_key'].should == ['attr4_value']
      u_hash.should == underscored_hash
    end

    let(:filtered_hash) { {"attr1_key"=>"attr1_value", "attr2_key"=>"attr2_value", "attr5_key" => "some Text", "attr6_key" => nil } }

    it "should include only ordered attributes" do
      DummyMarshal.filter_attributes(input_hash).should == filtered_hash
    end

    it "should not include any attributes with an Array value" do
      DummyMarshal.filter_attributes(input_hash).should_not include("attr4_key")
    end

    it "should subsitute the hash value iff that hash has the key 'text'" do
      DummyMarshal.filter_attributes(input_hash)['attr5_key'].should == "some Text"
    end

    it "should nil the hash value if that hash does not have the key 'text'" do
      DummyMarshal.filter_attributes(input_hash)['attr6_key'].should be_nil
    end

    it "should create a new instance from filtered attributes" do
      obj = DummyMarshal.new(DummyMarshal.filter_attributes(input_hash))
      obj.attr1_key.should == "attr1_value"
      obj.attr2_key.should == "attr2_value"
      obj.methods.should include(:Attr3Key)

      # this attribute is NOT returned from .attr_order, so it was
      # filtered out!
      obj.methods.should_not include(:attr3_key)
      obj.Attr3Key.should == nil

      # this was filtered out because the value was an Array
      obj.attr4_key.should == nil

      # This was set to this value because the input value was a Hash
      # AND it had a key 'text'
      obj.attr5_key.should == "some Text"

      # This was set to nil because the input value was a Hash      
      obj.attr6_key.should == nil
    end
  end
  
  describe "#create_hash" do
    it "should create an internal hash that holds arg1 to from_hash method" do
      dummy =  DummyMarshal.from_hash(input_hash)
      dummy.create_hash.should == underscored_hash
    end
  end

  describe "#to_hash" do

    let(:input_hash_with_children) { { 'attr1_key' => "attr1_value", 'attr2_key' => "attr2_value", 'Attr3Key' => "Attr3Value", 'attr4_key' => ["attr4_value"], 'attr5_key' => {'text' => "some Text" }, "attr6_key" => {:my_key => "my Value"}, 'dummyChildren' => [{'attr1' => 'child_val1', 'attr2' => 'child_val2'}] }}

    it "should create the correct object graph " do
      dummy_marshal_obj =  DummyMarshal.from_hash(input_hash_with_children)
      dummy_marshal_obj.attr1_key.should == "attr1_value"
      dummy_marshal_obj.attr2_key.should == "attr2_value"
      dummy_marshal_obj.attr4_key.should == nil
      dummy_marshal_obj.attr5_key.should == "some Text"
      dummy_marshal_obj.attr6_key.should == nil
      dummy_marshal_obj.dummy_children.length.should == 1
      dummy_marshal_obj.dummy_children[0].attr1.should == "child_val1"
      dummy_marshal_obj.dummy_children[0].attr2.should == "child_val2"
    end
    
  end

  describe "#from_hash" do
    let(:input_hash_with_belongs) { { 'type' => 'ASequence', 'attr1_key' => 'attr1_value', 'bDataSet' => { 'type' => 'BDataSet', 'name' => 'First Data' }, 'otherData' => { 'type' => 'BDataSet', 'name' => 'Second Data' } } }

    it 'should create objects for both associations' do
      a_seq = ASequence.from_hash(input_hash_with_belongs)
      a_seq.b_data_set.should be_instance_of(BDataSet)
      a_seq.other_data.should be_instance_of(BDataSet)
      a_seq.other_data.name.should == 'Second Data'
    end
  end
end
