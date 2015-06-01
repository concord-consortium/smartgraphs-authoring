require 'spec_helper'

describe Activity do
  describe "name" do
    it "must have a name" do
      subject.name = ""
      subject.should_not be_valid
      subject.name = 'bob'
      subject.should be_valid
    end
  end

  describe "publication_status" do
    before(:each) do
      subject.name = "a valid name"
    end

    it "should have a publication status" do
      should.respond_to? :publication_status
    end

    it "should use the default value of private" do
      subject.publication_status.should eql 'private'
    end

    it "should allow 'public' as a value" do
      subject.publication_status = 'public'
      subject.should be_valid
    end

    it "shouldn't allow 'foo' as a value" do
      subject.publication_status = 'foo'
      subject.should_not be_valid
    end
  end


  describe "associations" do
    let(:physics) { FactoryGirl.create(:subject_area, :name => 'physics' ) }
    let(:math) { FactoryGirl.create(:subject_area, :name => 'math' ) }
    let(:mid) { FactoryGirl.create(:grade_level, :name => '6-9' ) }
    let(:high) { FactoryGirl.create(:grade_level, :name => '10-12' ) }

    before(:each ) do
      subject.name = "testing"
    end

    describe "subect_areas" do
      it "should have no subject areas by default" do
        subject.subject_areas.should be_empty
      end

      it "can belong to multiple subject areas" do
        subject.subject_areas = [physics,math]
        subject.subject_areas.should include(math)
        subject.subject_areas.should include(physics)
      end
    end

    describe "grade_levels" do
      it "should be empty by default" do
        subject.grade_levels.should be_empty
      end

      it "can belong to multiple subject areas" do
        subject.grade_levels = [mid,high]
        subject.grade_levels.should include(mid)
        subject.grade_levels.should include(high)
      end
    end
  end

  context 'when there are labels' do
    let (:activity_with_labels) {
      act = FactoryGirl.create(:activity_with_labelset) # 3 labels
      act.pages.first.pick_a_point_sequences.create({:answer_with_label => true, :title => 'Test a label', :initial_prompt => 'Label this!', :give_up => 'Wrong', :confirm_correct => 'Right'}) # 4th label
      act.save
      act
    }

    describe '#labels' do
      it 'should return an array of labels belonging to the activity' do
        activity_with_labels.labels.length.should eq(4)
      end

      it 'should not include duplicates' do
        pdgp = FactoryGirl.create(:predefined_graph_pane)
        activity_with_labels.pages[1].predefined_graph_panes << FactoryGirl.create(:predefined_graph_pane)
        pdgp.graph_labels << GraphLabel.find_by_name('Label for Label this!') # This could create a dupe
        activity_with_labels.labels.length.should eq(4)
      end
    end

    describe '#free_labels' do
      it 'should return only labels which do not belong to a LabelSet' do
        activity_with_labels.free_labels.length.should eq(1)
        activity_with_labels.free_labels.first.name.should == 'Label for Label this!'
      end
    end
  end

  describe "copy" do
    subject do
      @data_set = DataSet.create(:name => "test")
      @graph_label1 = GraphLabel.new(:text => "Graph Label 1", :name => "Label 1", :x_coord => 0.9, :y_coord => 3.2)
      @graph_label2 = GraphLabel.new(:text => "Graph Label 2", :name => "Label 2", :x_coord => 3.9, :y_coord => 5.2)
      @label_set = LabelSet.new(:name => "test label set")
      @label_set.graph_labels << @graph_label1;
      @label_set.graph_labels << @graph_label2;
      @page = Page.new(:name => "test")
      @prediction = PredictionGraphPane.create!(:title => 'Prediction')
      @page.prediction_graph_panes << @prediction
      @predefined = PredefinedGraphPane.new({
        :title => "test",
        # :page => @page,
        :included_graphs => [@prediction],
        :y_label => "y",
        :y_min   => 0.0,
        :y_max   => 1.0,
        :y_ticks => 0.1,
        :x_label => "x",
        :x_min   => 0.0,
        :x_max   => 10.0,
        :x_ticks => 1.0,
        :data_sets => [@data_set],
        :label_sets => [@label_set]
      })
      @sequence = PickAPointSequence.create({
        :title            => "string",
        :initial_prompt   => "text",
        :give_up          => "text",
        :confirm_correct  => "text",
        :data_set         => @data_set
      })
      @page.pick_a_point_sequences << @sequence
      @page.predefined_graph_panes << @predefined
      @original = Activity.create({
        :name       => "testing",
        :data_sets  => [@data_set],
        :label_sets => [@label_set],
        :pages      => [@page]
      })
      @original.copy_activity
    end

    let(:derivative) { FactoryGirl.create(:data_set, :name => 'Derivative', :derivative_of_id => @data_set.id) }

    it "should match original" do
      subject.to_hash.should == @original.to_hash
    end

    it "should have a label set with two graph labels" do
      subject.label_sets.count.should == 1
      subject.label_sets.first.name.should == 'test label set'
      subject.label_sets.first.is_for_users.should be_false
      subject.label_sets.first.graph_labels.count.should == 2
    end

    it "should have a label set with the correct graph labels" do
      gl1 = subject.label_sets.first.graph_labels.first
      gl1.text.should == "Graph Label 1"
      gl1.name.should == "Label 1"
      gl1.x_coord.should == 0.9
      gl1.y_coord.should == 3.2

      gl1 = subject.label_sets.first.graph_labels.last
      gl1.text.should == "Graph Label 2"
      gl1.name.should == "Label 2"
      gl1.x_coord.should == 3.9
      gl1.y_coord.should == 5.2
    end

    it 'should retain derivative relationships' do
      subject
      @original.data_sets << derivative
      this_copy = @original.copy_activity
      this_copy.data_sets.find_by_name('Derivative').derivative_of_id.should_not be_nil
    end
  end
end
