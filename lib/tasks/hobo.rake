namespace :hobo do
  desc 'generate the app/views/taglibs/auto folder of files'
  task :generate_taglibs => :environment do
    # this task actually doesn't have to do anything hobo will generate
    # the files itself just by loading the environment
  end
end