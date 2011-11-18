Given /^I am on the [A|a]ctivities page$/ do
  visit '/activities'
end

When /^I create (?:a new|an) activity:$/ do |text|
  activity_def = YAML.load(text)

  @activity = create_activity(activity_def)
end

Then /^I should get correct json$/ do
  # load the json file for this activity, by name
  filename = @activity.name.gsub(/\s+/,'').underscore + '.json'
  expected_json = JSON.parse(File.read(File.join(File.dirname(__FILE__), "..", "expected-output", filename)))
  activity_url = activity_path(:id => @activity.id, :format => 'json')
  visit activity_url
  actual_json = JSON.parse(page.driver.response.body)
  actual_json.should == expected_json
end

def create_activity(activity_def)
  visit '/activities'
  click_link 'New Activity'
  fill_in 'activity_name', :with => activity_def[:name]
  click_button 'Create Activity'

  activity_url = current_url
  activity_def[:units].each{|unit_def| create_unit(unit_def); visit activity_url } if activity_def[:units]
  activity_def[:pages].each{|page_def| create_page(page_def); visit activity_url } if activity_def[:pages]
  return Activity.last
end

def create_unit(unit_def)
  visit '/units'
  click_link 'New Unit'
  fill_in 'unit_name', :with => unit_def[:name]
  fill_in 'unit_abbreviation', :with => unit_def[:abbreviation]
  click_button 'Create Unit'
end

def create_page(page_def)
  click_link 'New Pages'
  fill_in 'page_name', :with => page_def[:name]
  fill_in 'page_text', :with => page_def[:text]
  click_button 'Create Page'

  page_url = current_url
  page_def[:panes].each{|pane_def| create_pane(pane_def); visit page_url } if page_def[:panes]
  create_sequence(page_def[:sequence]) if page_def[:sequence]
end

def create_pane(pane_def)
  case pane_def[:type]
  when "ImagePane"
    click_link 'New Image pane'
    fill_in 'image_pane_name', :with => pane_def[:name]
    fill_in 'image_pane_url', :with => pane_def[:url]
    fill_in 'image_pane_license', :with => pane_def[:license]
    fill_in 'image_pane_attribution', :with => pane_def[:attribution]
    click_button 'Create Image pane'
  when "PredefinedGraphPane"
    click_link 'New Predefined graph pane'
    fill_in 'predefined_graph_pane_title', :with => pane_def[:title]
    fill_in 'predefined_graph_pane_data', :with => pane_def[:data]

    fill_in 'predefined_graph_pane_y_label', :with => pane_def[:y][:label]
    fill_in 'predefined_graph_pane_y_min', :with => pane_def[:y][:min]
    fill_in 'predefined_graph_pane_y_max', :with => pane_def[:y][:max]
    fill_in 'predefined_graph_pane_y_ticks', :with => pane_def[:y][:ticks]
    select pane_def[:y][:unit], :from => 'predefined_graph_pane[y_unit_id]'

    fill_in 'predefined_graph_pane_x_label', :with => pane_def[:x][:label]
    fill_in 'predefined_graph_pane_x_min', :with => pane_def[:x][:min]
    fill_in 'predefined_graph_pane_x_max', :with => pane_def[:x][:max]
    fill_in 'predefined_graph_pane_x_ticks', :with => pane_def[:x][:ticks]
    select pane_def[:x][:unit], :from => 'predefined_graph_pane[x_unit_id]'
    click_button 'Create Predefined graph pane'
  when "SensorGraphPane"
    click_link 'New Sensor graph pane'
    fill_in 'sensor_graph_pane_title', :with => pane_def[:title]

    fill_in 'sensor_graph_pane_y_label', :with => pane_def[:y][:label]
    fill_in 'sensor_graph_pane_y_min', :with => pane_def[:y][:min]
    fill_in 'sensor_graph_pane_y_max', :with => pane_def[:y][:max]
    fill_in 'sensor_graph_pane_y_ticks', :with => pane_def[:y][:ticks]
    select pane_def[:y][:unit], :from => 'sensor_graph_pane[y_unit_id]'

    fill_in 'sensor_graph_pane_x_label', :with => pane_def[:x][:label]
    fill_in 'sensor_graph_pane_x_min', :with => pane_def[:x][:min]
    fill_in 'sensor_graph_pane_x_max', :with => pane_def[:x][:max]
    fill_in 'sensor_graph_pane_x_ticks', :with => pane_def[:x][:ticks]
    select pane_def[:x][:unit], :from => 'sensor_graph_pane[x_unit_id]'
    click_button 'Create Sensor graph pane'
  when "TablePane"
    click_link 'New Table pane'
    fill_in 'table_pane_title', :with => pane_def[:title]
    click_button 'Create Table pane'
  end
end

def create_sequence(sequence_def)
  case sequence_def[:type]
  when "InstructionSequence"
    click_link 'New Instruction sequence'
    fill_in 'instruction_sequence_text', :with => sequence_def[:text]
    click_button 'Create Instruction sequence'
  when "PickAPointSequence"
    click_link 'New Pick a point sequence'
    fill_in 'pick_a_point_sequence_title', :with => sequence_def[:title]
    fill_in 'pick_a_point_sequence_initial_prompt', :with => sequence_def[:initialPrompt]
    fill_in 'pick_a_point_sequence_correct_answer_x', :with => sequence_def[:correctAnswerX]
    fill_in 'pick_a_point_sequence_correct_answer_y', :with => sequence_def[:correctAnswerY]
    fill_in 'pick_a_point_sequence_give_up', :with => sequence_def[:giveUp]
    fill_in 'pick_a_point_sequence_confirm_correct', :with => sequence_def[:confirmCorrect]
    click_button 'Create Pick a point sequence'
  when "NumericSequence"
    pending "numeric implementation"
  when "ConstructedResponseSequence"
    pending "constructed response implementation"
  end
end
