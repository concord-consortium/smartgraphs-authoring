namespace :sg do
  desc 'checkout and build smartgraphs rutime'
  task :build => :environment do
    checkout_path = File.join(Rails.root,'tmp','sg-runtime')
    build_in_path = File.join(checkout_path,'tmp','build','static')
    copy_to_path = File.join(Rails.root,'public')

    unless File.exists? checkout_path
      %x[git clone git://github.com/concord-consortium/Smartgraphs.git #{checkout_path}]
    end
    %x[cd #{checkout_path}]
    %x[git pull]
    if File.exists? build_in_path
      %x[rm -r #{build_in_path}]
    end
    current_rvm = %x[rvm current]
    %x[rvm use 1.9.2-p290@smartgraphs --createa]
    %x[bundle install]
    %x[bundle exec sc-build smartgraphs -r --languages=en]
    %x[cp -r #{build_in_path} #{copy_to_path}]
    %x[cd #{Rails.root}]
    %x[rvm use #{current_rvm}]
  end
end
