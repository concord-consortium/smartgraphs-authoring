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
  activity_def[:pages].each{|page_def| create_page(page_def); visit activity_url } if activity_def[:pages]
  return Activity.last
end

def create_page(page_def)
  click_link 'New Pages'
  fill_in 'page_name', :with => page_def[:name]
  fill_in 'page_text', :with => page_def[:text]
  click_button 'Create Page'

  page_url = current_url
  page_def[:panes].each{|pane_def| create_pane(pane_def); visit page_url } if page_def[:panes]
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
    pending "Predefined graph implementation"
  when "SensorGraph"
    pending "SensorGraph implementation"
  when "TablePane"
    pending "TablePane implementation"
  end
end
