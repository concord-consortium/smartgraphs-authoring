module BetterHashDiff
  def diff(other)
    self.keys.inject({}) do |memo, key|
      unless self[key] == other[key]
        memo[key] = [self[key], other[key]] 
      end
      memo
    end
  end
end

# Cucumber doesn't have a scenario-level pending keyword: http://stackoverflow.com/a/5983793/306084
Given /^PENDING/ do
  pending
end

Given(/^I am logged in as (?:a|an) (admin|user) named '(\w+)'$/) do |admin_text,name|
  admin = admin_text == 'admin' ? true : false
  do_login(name,admin)
end

Given(/^I am on the [A|a]ctivities page$/) do
  visit '/activities'
end

Given(/^I am on [M|m]y [A|a]ctivities page$/) do
  visit '/activities/my_activities'
end

Given(/^I am on the [I|i]ndex page$/) do
  visit '/'
end

Given(/^There is a subject area called\s+"(.*)"$/) do |name|
  @subject = SubjectArea.create(:name => name)
end

Given(/^There is a grade level called\s+"(.*)"$/) do |name|
  @subject = GradeLevel.create(:name => name)
end


Then(/^I should see a link to "([^"]*)" in the navigation$/) do |url|
  within "ul.navigation" do |scope|
    has_link_to?(scope,url)
  end
end


When(/^I create (?:a new|an) activity:$/)do |text|
  activity_def = YAML.load(text)
  @activity = create_activity(activity_def)
end

Then(/^when serialization is fixed I should be able to copy the activity/) do
  pending "We need to come back to check serialization on this"
  the_copy = @activity.copy_activity
  the_copy.to_hash.to_s.should == @activity.to_hash.to_s
end

Then(/^I should be able to copy the activity/) do
  the_copy = @activity.copy_activity
  the_copy.to_hash.to_s.should == @activity.to_hash.to_s
end

Then(/^The activity should be (public||private)$/) do |p|
  @activity.publication_status.should == p.downcase
end

Then(/^The activity should be in the "([^"]*)" subject area/) do |subj|
  @activity.subject_areas.map(&:name).should include(subj)
end

Then(/^The activity should be in the "([^"]*)" grade level/) do |level|
  @activity.grade_levels.map(&:name).should include(level)
end

Then(/^I should see an activity listed for the grade level "([^"]*)"$/) do |level|
  visit '/activities'
  within ".grade_levels" do |scope|
    scope.should have_content level
  end
end

Then(/^I should see an activity listed for the subject area "([^"]*)"$/) do |subject|
  visit '/activities'
  within ".subject_areas" do |scope|
    scope.should have_content subject
  end
end

Then(/^I should see "([^"]*)" in the listing$/) do |name|
  visit '/activities'
  within "ul.activities" do |scope|
    scope.should have_content name
  end
end

Then(/^I should see "([^"]*)" in my activities list/) do |name|
  visit '/activities/my_activities'
  within "ul.activities" do |scope|
    scope.should have_content name
  end
end

Then(/^I should see "([^"]*)" in\s*(?:[tT]he)\s*all activities list/) do |name|
  visit '/activities/all_activities'
  within "ul.activities" do |scope|
    scope.should have_content name
  end
end

Then(/^I should not see "([^"]*)" in the listing$/) do |name|
  visit '/activities'
  page.should_not have_content(name)
end

Then(/^I should be able to edit "([^"]*)"$/) do |name|
  a = Activity.find_by_name(name)
  visit activity_path(a)
  edit_url = edit_activity_path(a)
  has_link_to?(page,edit_url)
end

Then(/^I should not be able to edit "([^"]*)"$/) do |name|
  a = Activity.find_by_name(name)
  visit activity_path(a)
  edit_url = edit_activity_path(a)
  (!has_link_to?(page,edit_url))
end

Then(/^I should be able to change the name of "([^"]*)"$/) do |name|
  a = Activity.find_by_name(name)
  visit edit_activity_path(a)
  new_name = "new_#{name}}"
  fill_in 'activity_name', :with => new_name
  click_button 'Save Activity'
  visit activity_path(a)
  page.should have_content(new_name)
end

Then(/^I should get correct json$/)do
  # load the json file for this activity, by name
  filename = @activity.name.gsub(/\s+/,'').underscore + '.json'
  expected_json = JSON.parse(File.read(File.join(File.dirname(__FILE__), "..", "expected-output", filename)))
  activity_url = activity_path(:id => @activity.id, :format => 'json')
  visit activity_url
  body = page.driver.respond_to?('response') ? page.driver.response.body : page.driver.body
  actual_json = JSON.parse(body.gsub(/.*<pre[^>]*>/,'').gsub(/<\/pre>.*/,''))
  # Uncomment if you want slightly better 
  # display of hash differences:
  #actual_json.extend BetterHashDiff
  #expected_json.extend BetterHashDiff
  #pp actual_json.diff(expected_json)
  actual_json.should == expected_json
end

def has_link_to?(context,url)
  return context.has_selector?("a[href=\"#{url}\"]")
end

def create_activity(activity_def)
  visit '/activities'
  click_link 'New Activity'
  fill_in 'activity_name', :with => activity_def[:name]
  fill_in 'activity_author_name', :with => activity_def[:author_name]
  if activity_def[:publication_status]
    select activity_def[:publication_status].capitalize, :from => 'activity[publication_status]'
  end
  
  if activity_def[:grade_levels]
    activity_def[:grade_levels].each do |grade_level|
      select grade_level.capitalize
    end
  end

  if activity_def[:subject_areas]
    activity_def[:subject_areas].each do |subject_area|
      select subject_area.capitalize
    end
  end

  click_button 'Create Activity'

  activity_url = current_url
  activity_def[:units].each{|unit_def| create_unit(unit_def); visit activity_url } if activity_def[:units]
  activity_def[:data_sets].each{|data_set_def| create_data_set(data_set_def); visit activity_url } if activity_def[:data_sets]  
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
  create_multiple_choice_sequencese(page_def[:multiple_choice_sequence]) if page_def[:multiple_choice_sequence]
end

def create_data_set(definition)
  click_link 'New Data set'
  fill_in 'data_set_name', :with => definition[:name]
  fill_in 'data_set_y_precision', :with => definition[:yPrecision]
  fill_in 'data_set_x_precision', :with => definition[:xPrecision]
  fill_in 'data_set_line_snap_distance', :with => definition[:lineSnapDistance]
  fill_in 'data_set_expression', :with => definition[:expression]
  select definition[:lineType].capitalize, :from => 'data_set[line_type]'
  select definition[:pointType].capitalize, :from => 'data_set[point_type]'
  fill_in 'data_set_data', :with => definition[:data]
  select definition[:xUnits], :from => 'data_set[x_unit_id]'
  select definition[:yUnits], :from => 'data_set[y_unit_id]'
  click_button 'Create Data set'
end

def create_data_set_model(definition)
  x_unit    = definition['x']['unit'] if definition['x']
  y_unit    = definition['y']['unit'] if definition['y']
  data       = definition['data'] || ""
  expression = definition['expression'] || ""
  name       = definition['data_set_name'] || 'default_data_set'
  x_unit = Unit.find_by_name(x_unit) if x_unit
  y_unit = Unit.find_by_name(y_unit) if y_unit
  atts = {
    :name       => name,
    :x_unit     => x_unit,
    :y_unit     => y_unit,
    :data       => data,
    :expression => expression
  }
  return DataSet.create!(atts)
end

def select_included_data_sets(included_defs = [])
  included_defs.each do |data_set_name|
    select_node = find(:css, '.select-many select')
    select_node.find(:xpath, XPath::HTML.option(data_set_name), :message => "cannot select option with text '#{data_set_name}'").select_option
  end
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
    
    fill_in 'predefined_graph_pane_y_label', :with => pane_def[:y][:label]
    fill_in 'predefined_graph_pane_y_min', :with => pane_def[:y][:min]
    fill_in 'predefined_graph_pane_y_max', :with => pane_def[:y][:max]
    fill_in 'predefined_graph_pane_y_ticks', :with => pane_def[:y][:ticks]
    
    fill_in 'predefined_graph_pane_x_label', :with => pane_def[:x][:label]
    fill_in 'predefined_graph_pane_x_min', :with => pane_def[:x][:min]
    fill_in 'predefined_graph_pane_x_max', :with => pane_def[:x][:max]
    fill_in 'predefined_graph_pane_x_ticks', :with => pane_def[:x][:ticks]
    
    select_included_graphs(pane_def[:included_graphs])
    select_included_data_sets(pane_def[:data_sets])
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

    select_included_graphs(pane_def[:included_graphs])

    click_button 'Create Sensor graph pane'
  when "PredictionGraphPane"
    click_link 'New Prediction graph pane'
    fill_in 'prediction_graph_pane_title', :with => pane_def[:title]

    fill_in 'prediction_graph_pane_y_label', :with => pane_def[:y][:label]
    fill_in 'prediction_graph_pane_y_min', :with => pane_def[:y][:min]
    fill_in 'prediction_graph_pane_y_max', :with => pane_def[:y][:max]
    fill_in 'prediction_graph_pane_y_ticks', :with => pane_def[:y][:ticks]
    select pane_def[:y][:unit], :from => 'prediction_graph_pane[y_unit_id]'

    fill_in 'prediction_graph_pane_x_label', :with => pane_def[:x][:label]
    fill_in 'prediction_graph_pane_x_min', :with => pane_def[:x][:min]
    fill_in 'prediction_graph_pane_x_max', :with => pane_def[:x][:max]
    fill_in 'prediction_graph_pane_x_ticks', :with => pane_def[:x][:ticks]
    select pane_def[:x][:unit], :from => 'prediction_graph_pane[x_unit_id]'

    select pane_def[:prediction_type], :from => 'prediction_graph_pane[prediction_type]'

    select_included_graphs(pane_def[:included_graphs])

    click_button 'Create Prediction graph pane'
  when "TablePane"
    click_link 'New Table pane'
    fill_in 'table_pane_title', :with => pane_def[:title]
    fill_in 'table_pane_x_label', :with => pane_def[:x_label] if pane_def[:x_label]
    fill_in 'table_pane_y_label', :with => pane_def[:y_label] if pane_def[:y_label]
    click_button 'Create Table pane'
  end
end

def select_included_graphs(included_def = [])
  (included_def || []).each do |graph_name|
    # select the graph to be included
    select_node = find(:css, '.custom.select-many select')
    select_node.find(:xpath, XPath::HTML.option(graph_name), :message => "cannot select option with text '#{graph_name}'").select_option
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
    fill_in 'pick_a_point_sequence_give_up', :with => sequence_def[:giveUp]
    fill_in 'pick_a_point_sequence_confirm_correct', :with => sequence_def[:confirmCorrect]
    select sequence_def[:dataSet], :from => 'pick_a_point_sequence[data_set_id]'

    if sequence_def[:correctAnswerX] || sequence_def[:correctAnswerY]
      fill_in 'pick_a_point_sequence_correct_answer_x', :with => sequence_def[:correctAnswerX]
      fill_in 'pick_a_point_sequence_correct_answer_y', :with => sequence_def[:correctAnswerY]
    else
      fill_in 'pick_a_point_sequence_correct_answer_x_min', :with => sequence_def[:correctAnswerXMin]
      fill_in 'pick_a_point_sequence_correct_answer_y_min', :with => sequence_def[:correctAnswerYMin]
      fill_in 'pick_a_point_sequence_correct_answer_x_max', :with => sequence_def[:correctAnswerXMax]
      fill_in 'pick_a_point_sequence_correct_answer_y_max', :with => sequence_def[:correctAnswerYMax]
    end
    click_button 'Create Pick a point sequence'
  when "NumericSequence"
    click_link 'New Numeric sequence'
    fill_in 'numeric_sequence_title', :with => sequence_def[:title]
    fill_in 'numeric_sequence_initial_prompt', :with => sequence_def[:initialPrompt]
    fill_in 'numeric_sequence_correct_answer', :with => sequence_def[:correctAnswer]
    fill_in 'numeric_sequence_tolerance', :with => sequence_def[:tolerance]
    fill_in 'numeric_sequence_give_up', :with => sequence_def[:giveUp]
    fill_in 'numeric_sequence_confirm_correct', :with => sequence_def[:confirmCorrect]
    select sequence_def[:dataSet], :from => 'numeric_sequence[data_set_id]'
    click_button 'Create Numeric sequence'
  when "ConstructedResponseSequence"
    click_link 'New Constructed response sequence'
    fill_in 'constructed_response_sequence_title', :with => sequence_def[:title]
    fill_in 'constructed_response_sequence_initial_prompt', :with => sequence_def[:initialPrompt]
    fill_in 'constructed_response_sequence_initial_content', :with => sequence_def[:initialContent]
    click_button 'Create Constructed response sequence'
  when "MultipleChoiceSequence"
    extract_multiple_choice_sequence!(sequence_def)
  when "SlopeToolSequence"
    create_slope_tool_sequence!(sequence_def)
  end

  sequence_url = current_url
  [:initialPromptPrompts, :giveUpPrompts, :confirmCorrectPrompts].each do |p|
    if sequence_def[p]
      # be sure to limit the prompt creation to one of the aside sections
      # eg initial-prompt-prompts-collection-section
      context = ".#{p.to_s.underscore.gsub(/_/,'-')}-collection-section"
      sequence_def[p].each do |prompt_def|
        create_prompt(prompt_def, context)
        visit sequence_url
      end
    end
  end
  sequence_def[:hints].each{|hint_def| create_hint(hint_def); visit sequence_url } if sequence_def[:hints]
end

def create_hint(hint_def)
  click_link 'New Text hint'
  fill_in 'text_hint_name', :with => hint_def[:name]
  fill_in 'text_hint_text', :with => hint_def[:text]
  click_button 'Create Text hint'

  # Create visual prompts
  hint_url = current_url
  hint_def[:prompts].each{|prompt_def| create_prompt(prompt_def); visit hint_url } if hint_def[:prompts]
end

def create_prompt(prompt_def, context = nil)
  case prompt_def[:type]
  when "RangeVisualPrompt"
    if context
      within(context) do
        click_link 'New Range visual prompt'
      end
    else
      click_link 'New Range visual prompt'
    end
    fill_in 'range_visual_prompt_name', :with => prompt_def[:name]
    fill_in 'range_visual_prompt_x_min', :with => prompt_def[:minX]
    fill_in 'range_visual_prompt_x_max', :with => prompt_def[:maxX]
    fill_in 'range_visual_prompt_color', :with => prompt_def[:color]
    click_button 'Create Range visual prompt'
  when "PointCircleVisualPrompt"
    if context
      within(context) do
        click_link 'New Point circle visual prompt'
      end
    else
      click_link 'New Point circle visual prompt'
    end
    fill_in 'point_circle_visual_prompt_name', :with => prompt_def[:name]
    fill_in 'point_circle_visual_prompt_point_x', :with => prompt_def[:pointX]
    fill_in 'point_circle_visual_prompt_point_y', :with => prompt_def[:pointY]
    fill_in 'point_circle_visual_prompt_color', :with => prompt_def[:color]
    click_button 'Create Point circle visual prompt'
  when "PointAxisLineVisualPrompt"
    if context
      within(context) do
        click_link 'New Point axis line visual prompt'
      end
    else
      click_link 'New Point axis line visual prompt'
    end
    fill_in 'point_axis_line_visual_prompt_name', :with => prompt_def[:name]
    fill_in 'point_axis_line_visual_prompt_point_x', :with => prompt_def[:pointX]
    fill_in 'point_axis_line_visual_prompt_point_y', :with => prompt_def[:pointY]
    fill_in 'point_axis_line_visual_prompt_color', :with => prompt_def[:color]
    select prompt_def[:axis], :from => 'point_axis_line_visual_prompt[axis]'
    click_button 'Create Point axis line visual prompt'
  end
end

# side-effect: Will remove :hints from mc_seq_def hash
# TODO: something safer?
def extract_multiple_choice_sequence!(mc_seq_def)
  click_link 'New Multiple choice sequence'
  fill_in 'multiple_choice_sequence_initial_prompt', :with => mc_seq_def[:initialPrompt]
  fill_in 'multiple_choice_sequence_give_up', :with => mc_seq_def[:giveUp]
  fill_in 'multiple_choice_sequence_confirm_correct', :with => mc_seq_def[:confirmCorrect]
  if mc_seq_def[:useSequentialFeedback] == true
    check 'multiple_choice_sequence_use_sequential_feedback'
  else
    uncheck 'multiple_choice_sequence_use_sequential_feedback' 
  end
  select mc_seq_def[:dataSetName], :from => 'multiple_choice_sequence[data_set_id]'
  click_button 'Create Multiple choice sequence'
  mc_seq_def[:choices].each do |choice_def|
    within('form.new.multiple-choice-choice') do
      fill_in 'multiple_choice_choice_name', :with => choice_def[:name]
      check('multiple_choice_choice_correct') if (choice_def[:correct] == true)
      unless (mc_seq_def[:useSequentialFeedback] == true)
        fill_in 'multiple_choice_choice_feedback', :with => choice_def[:feedback]
      end
      click_button 'Add'
    end
  end
  if (mc_seq_def[:useSequentialFeedback] == true)
    within('form.new.multiple-choice-hint') do
      mc_seq_def[:hints].each do |hint_def|
        fill_in 'multiple_choice_hint_name', :with => hint_def[:name]
        fill_in 'multiple_choice_hint_hint_text', :with => hint_def[:feedback]
        click_button 'Add'
      end
    end
  end
  # multiple choice handles hints differently, so delete them from the hash
  mc_seq_def.delete(:hints)
end 


def create_slope_tool_sequence!(opts)
 click_link 'New Slope tool sequence'
  select opts[:case_type], :from => 'slope_tool_sequence[case_type]'
  select opts[:point_constraints], :from => 'slope_tool_sequence[point_constraints]'
  fill_in 'slope_tool_sequence_first_question', :with => opts[:first_question]
  fill_in 'slope_tool_sequence_slope_variable_name', :with => opts[:slope_variable_name]
  fill_in 'slope_tool_sequence_x_min', :with => opts[:x_min]
  fill_in 'slope_tool_sequence_y_min', :with => opts[:y_min]
  fill_in 'slope_tool_sequence_x_max', :with => opts[:x_max]
  fill_in 'slope_tool_sequence_y_max', :with => opts[:y_max]
  fill_in 'slope_tool_sequence_tolerance', :with => opts[:tolerance]
  select opts[:data_set_name], :from => 'slope_tool_sequence[data_set_id]'
  click_button 'Create Slope tool sequence'
end


