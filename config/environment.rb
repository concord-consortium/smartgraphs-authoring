# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
SgAuthoring::Application.initialize!
Mime::Type.register "text/json", :runtime_json
