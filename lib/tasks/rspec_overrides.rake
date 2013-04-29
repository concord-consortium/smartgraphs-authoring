require 'rspec/core'
require 'rspec/core/rake_task'

# remove the old rake task for running request specs
tasks = Rake.application.instance_variable_get '@tasks'
tasks.delete 'spec:requests'

namespace :spec do
  # Overrides the RSpec request specs
  desc "Run the code examples in spec/requests"
  RSpec::Core::RakeTask.new(:requests => "db:test:prepare") do |t|
    t.pattern = './spec/requests/**/*_spec.rb'
    # make sure that you run the request specs, (groups/examples).
    t.rspec_opts = '--tag type:request'
  end

  desc "Run all code examples, including slow examples"
  task :all => ['spec', 'spec:requests']
end
