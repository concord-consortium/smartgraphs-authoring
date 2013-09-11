require 'spec_helper'

describe PredefinedGraphPane do
  let (:graph_pane) { FactoryGirl.create(:predefined_graph_pane) }
  let (:dataset_a) { FactoryGirl.create(:data_set, :name => "dataset_a") }
  let (:dataset_b) { FactoryGirl.create(:data_set, :name => "dataset_b") }

  describe "validations" do
    # TODO: anything we want to validate in our model?
  end

  describe "graph_type" do
    it 'returns a string describing the class name' do
      graph_pane.graph_type.should == "PredefinedGraphPane"
    end
  end

  describe "included_datasets" do
    it 'includes data_sets' do
      graph_pane.data_sets << dataset_a
      graph_pane.data_sets << dataset_b
      graph_pane.save
      graph_pane.included_datasets.should =~ [{"name"=>"dataset_a", "inLegend"=>false}, {"name"=>"dataset_b", "inLegend"=>false}]
    end
  end

  describe 'label association' do
    it 'only associates non-LabelSet GraphLabels' do
      # http://stackoverflow.com/q/18721695/306084
      ls = FactoryGirl.create(:full_label_set)
      free_labels_length = graph_pane.graph_labels.length
      label_set_label = ls.graph_labels.first
      label_set_label.parent_id.should == ls.id
      label_set_label.parent_type.should == 'LabelSet'
      # This association will take the GraphLabel out of the LabelSet
      graph_pane.graph_labels << ls.graph_labels.first
      graph_pane.graph_labels.length.should eq(free_labels_length + 1)
      label_set_label.parent_id.should == graph_pane.id
      label_set_label.parent_type.should == 'PredefinedGraphPane'
    end
  end

  describe "#to_hash" do
    let(:expected_hash) {
      {"type"=>"PredefinedGraphPane", "title"=>'predefined_graph_pane_3', "yLabel"=>'y label', "yMin"=>0.0, "yMax"=>10.0, "xLabel"=>'x label', "xMin"=>0.0, "xMax"=>10.0, "yTicks"=>10.0, "xTicks"=>10.0, "showCrossHairs"=>false, "showToolTipCoords"=>false, "showGraphGrid"=>false, "includedDataSets"=>[]}
    }

    it "matches our expected hash" do
      expected_hash['title'] = graph_pane.title
      graph_pane.to_hash.should == expected_hash
    end

    describe "with some interesting attributes" do
      let(:expected_hash) {
        {"type"=>"PredefinedGraphPane", "title"=>"predefined_graph_pane_4", "yLabel"=>"y label", "yMin"=>0.0, "yMax"=>10.0, "xLabel"=>"x label", "xMin"=>0.0, "xMax"=>10.0, "yTicks"=>10.0, "xTicks"=>10.0, "showCrossHairs"=>false, "showToolTipCoords"=>false, "showGraphGrid"=>false, "includedDataSets"=>[{"name"=>"dataset_a", "inLegend"=>false}, {"name"=>"dataset_b", "inLegend"=>false}]}
      }

      it "matches our expected hash" do
        expected_hash['title'] = graph_pane.title
        graph_pane.data_sets << dataset_a
        graph_pane.data_sets << dataset_b
        graph_pane.save
        graph_pane.to_hash.should == expected_hash
      end

      it "allows datasets to appear in legend" do
        # pending 'This is working in console but not in rspec.'
        graph_pane.data_sets << dataset_a
        graph_pane.data_sets << dataset_b
        graph_pane.data_set_panes.first.in_legend = true

        graph_pane.to_hash.should have_key "includedDataSets"
        graph_pane.to_hash['includedDataSets'].length.should eq(2)
        graph_pane.to_hash['includedDataSets'].first['inLegend']
        graph_pane.to_hash['includedDataSets'].last['inLegend'].should be_false
      end

      it 'includes any labelsets' do
        graph_pane.label_sets << FactoryGirl.create(:label_set)
        graph_pane.to_hash.should have_key 'labelSetNames'
      end

      it 'includes any labels' do
        graph_pane.graph_labels << FactoryGirl.create(:graph_label)
        graph_pane.to_hash.should have_key 'labels'
        graph_pane.to_hash['labels'].length.should eq(1)
      end
    end
  end

  describe "when the pane contains an animation" do
    let (:activity) { FactoryGirl.create(:activity_with_animated_graph_pane)}

    describe "#to_hash" do
      it "contains the animation" do
        pane = activity.pages.first.predefined_graph_panes.first
        pane.to_hash['animation'].should == activity.animations.first.name
      end
    end

    describe "when the activity containing the animated PredefinedGraphPane is copied" do
      it "correctly references the animation in the copy" do
        pending "Something's up ... this behavior works with real records, doesn't work on FactoryGirl created activity"
        copy = activity.copy_activity
        pane = copy.pages.first.predefined_graph_panes.first
        animation = copy.animations.first
        pane.animation.should == animation
      end
    end
  end

  describe "included graphs" do
    # TODO: This might be going away sometime:
    before(:each) do
      @included_graph = double('PredefinedGraphPane')
      @included_graph.stub(:get_indexed_path => "fake/path/here")
      @test_subject = subject
      @test_subject.stub(:included_graphs => [@included_graph])
    end

    it "should match our expected hash" do
      @test_subject.to_hash.should include({"includeAnnotationsFrom"=>["fake/path/here"]})
    end
  end

end
