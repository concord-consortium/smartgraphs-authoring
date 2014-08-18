if File.exists?("#{::Rails.root.to_s}/config/mailer.yml") || ::Rails.env == "test" || ::Rails.env == "cucumber"
  require "action_mailer"
  if ::Rails.env == "test" || ::Rails.env == "cucumber"
    puts "Overriding ActionMailer config and setting test mode"
    ActionMailer::Base.delivery_method = :test
  else
    ActionMailer::Base.delivery_method = :smtp
    ActionMailer::Base.smtp_settings = YAML.load_file(Rails.root.join('config', 'mailer.yml'))[:smtp].try(:to_options)
  end
end
