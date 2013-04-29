require 'spec_helper'
# rspec -f s  --tag type:request spec/requests/login_spec.rb
# OR
# rake spec:requests
describe "Login" do

  describe "Admin Factory Girl" do
    let(:password) { 'admin1234' }
    subject do
      create(:admin)
    end

    before do
      visit user_login_url
    end

    it "should redirect to the login page" do
      page.status_code.should == 200
      current_path.should == '/login'
      has_field? 'login', :type => :text
      has_field? 'password', :type => :password
      has_checked_field? 'remember-me'
      has_button? 'Login'
      has_link? 'Signup'
      has_link? 'Forgotten password?'
    end

    it "should log in" do
      fill_in "login", :with => subject.email_address
      fill_in "password", :with => password
      click_button 'Login'
      current_path.should == root_path
      has_content? "You have logged in"
      has_link? "Logged in as #{subject.name}"
    end

    it "should fail to log in with the wrong user name" do
      fill_in "login", :with => "foo"
      fill_in "password", :with => password
      click_button 'Login'
      current_path.should == '/login'
      has_content? "You did not provide a valid Email address and Password!"
    end
  end

  context "Administrator" do
    let(:password) { 'password2013' }

    subject do
      u = User.find_or_create_by_name("Joe Blow") do |u|
        u.email_address = 'joeblow@example.com'
        u.password = u.password_confirmation = password
        u.state = 'active'
        u.administrator = true
      end
      u.save!
      u
    end

    context "though the Login page" do
      before do
        visit user_login_url
      end

      it "should redirect to the correct page" do
        fill_in "login", :with => subject.email_address
        fill_in "password", :with => password
        click_button 'Login'
        # save_and_open_page
        current_path.should == '/'
        has_content? "Welcome To The SmartGraphs Authoring Tool"
      end
    end

    context  "through the development URL" do
      before do
        login_dev(subject.email_address)
      end

      it "should redirect to the correct page" do
        page.status_code.should == 200

        current_path.should == '/'
        has_content? "Welcome To The SmartGraphs Authoring Tool"
      end

      it "should store the session in a cookie" do
        cookie_session_id.should_not be_empty
        cookie_user.id.should == subject.id
        cookie_user.email_address.should == subject.email_address
      end
    end

  end
end
