module RequestMacros

  def login_dev(email_address)
    # will change if :login attribute on User model is changed
    visit "/dev/set_current_user?login=#{email_address}"
  end

  def cookie_jar
    Capybara.current_session.driver.browser.current_session.instance_variable_get(:@rack_mock_session).cookie_jar
  end

  def app_cookie
    raise "Not using the Cookie Store" unless SgAuthoring::Application.config.session_store == ActionDispatch::Session::CookieStore

    # key, "_sg-authoring_session", used to store the application session
    # set in session_store.rb
    key = SgAuthoring::Application.config.session_options[:key]

    encoded_cookie = cookie_jar.to_hash[key]
    Marshal.load(ActiveSupport::Base64.decode64(encoded_cookie))
  end

  def cookie_session_id
    app_cookie["session_id"]
  end

  def cookie_user
    user_id = app_cookie["user"].split(':')[1]
    User.find(user_id)
  end

  # from
  # http://stackoverflow.com/questions/6729786/how-to-select-date-from-a-select-box-using-capybara-in-rails-3
  def select_by_id(id, options = { })
    field = options[:from]
    option_xpath = "//*[@id='#{ field}']/option[#{id}]"
    option_text = find(:xpath, option_xpath).text
    select option_text, :from => field
  end

  def select_date(date, options = { })
    raise ArgumentError, 'from is a required option' if options[:from].blank?
    field = options[:from].to_s
    select date.year.to_s,               :from => "#{ field}_1i"
    select Date::MONTHNAMES[date.month], :from => "#{ field}_2i"
    select date.day.to_s,                :from => "#{field}_3i"
  end
end
