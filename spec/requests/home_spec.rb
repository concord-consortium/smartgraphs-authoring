require 'spec_helper'

describe "Home page" do
  before do
    visit root_url
  end
  it "should be on the home page" do
    page.status_code.should == 200
    current_path.should == '/'
    has_content? "Welcome To The SmartGraphs Authoring Tool"
  end

end
