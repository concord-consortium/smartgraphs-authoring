# encoding: UTF-8

Given /^(?:[Tt]hese)\s*[Gg]rade [Ll]evels exist$/ do |grade_levels|
  GradeLevel.create!(grade_levels.hashes)
end

Given /^(?:[Tt]hese)\s*[Ss]ubject [Aa]reas exist$/ do |subject_areas|
  SubjectArea.create!(subject_areas.hashes)
end

Given /^(?:[T|t]hese)\s*[A|a]ctivities exist$/ do |activities|
  activities.hashes.each do |act|
    act['grade_levels']  = act['grade_levels'].split(",").map {|g| GradeLevel.find_by_name(g)}
    act['subject_areas'] = act['subject_areas'].split(",").map{|s| SubjectArea.find_by_name(s)}
  end
  Activity.create!(activities.hashes)
end

When /^I am on the search page$/ do
  visit '/activities'
end

When /^I search for "(.*)"$/ do |search|
  fill_in 'search', :with => search
end

When /^I check "(.*)" for "(.*)"$/ do |selection,option|
  option = option.singularize
  class_name = option.camelcase.constantize
  id = class_name.find_by_name(selection).id
  checkbox_id = "check_many_#{option}_#{id}"
  check(checkbox_id)
end

Then /^I click on search/ do
  click_button('search →')
end

Then(/^I should see "([^"]*)" in the search results/) do |name|
  within "ul.activities" do |scope|
    scope.should have_content name
  end
end

Then(/^I should not see "([^"]*)" in the search results$/) do |name|
  within "ul.activities" do |scope|
    page.should_not have_content(name)
  end
end
