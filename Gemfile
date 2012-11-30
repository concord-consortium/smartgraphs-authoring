source 'http://rubygems.org'

gem 'rails', '3.0.10'
gem "hobo", "= 1.3.0.RC2"
gem "acts_as_list"

group :development do
  gem 'ffi', '1.0.9'
  gem 'sqlite3'
  gem "capistrano-ext", :require => "capistrano"
  gem "haml"
  # gem 'ruby-debug19', :require => 'ruby-debug'
  # ruby-debug has ruby version deps.
  # use 'binding.pry' instead of 'debugger'
  # see: http://pry.github.com/screencasts.html
  gem 'pry'
  gem 'pry-doc'
  gem 'pry-stack_explorer'
  gem 'pry-nav'
  gem 'awesome_print'
  gem 'railroady' 
  gem 'guard'
  gem 'guard-rspec'
  gem 'rb-fsevent'
end

group :test do
  gem 'pry'
  gem 'pry-doc'
  gem 'pry-stack_explorer'
  gem 'pry-nav'
  gem 'sqlite3'
  gem 'cucumber-rails'
  gem "rspec-rails", ">= 2.5.0"
  gem 'database_cleaner'
  gem 'launchy'
end

group :production do
  # gem 'mysql'
  gem 'mysql2', '~> 0.2.7'
end
