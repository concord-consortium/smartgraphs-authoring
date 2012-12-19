namespace :sg do
  desc 'checkout and build smartgraphs runtime'
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

  desc 'serialize [activity_id] semantic json to file activity_<activity_id>.json'
  task :serialize, [:activity_id] => [:environment]  do |t,args|
    id  = args[:activity_id]
    act = Activity.find(id)
    File.open("activity_#{id}.json", "w") do |io|
      io.write act.to_hash.to_json
    end
  end

  desc 'serialize [activity_id] runtime json to file activity_<activity_id>.runtime.json'
  task :serialize_runtime, [:activity_id] => [:environment]  do |t,args|
    id  = args[:activity_id]
    act = Activity.find(id)
    c = Converter.new()
    File.open("activity_#{id}.runtime.json", "w") do |f|
      f.write c.convert(act.to_hash.to_json)
    end
  end

  desc "serialize runtime json for all activities to json/activity_<activity_id>.runtime.json"
  task :serialize_runtime_all => [:environment]  do |t|
    FileUtils.mkdir_p 'json'
    c = Converter.new()
    errors = File.open("json/errors.txt", "w")
    Activity.all.each do |activity|
      json = c.convert(activity.to_hash.to_json)
      if json.length > 0
        f = File.open("json/activity_#{activity.id}.runtime.json", "w")
        f.write(json)
      else
        errors.write("#{activity.id}\n")
      end
    end
  end

  desc 'marshal serialized [activity_id] from tmp file'
  task :marshal, [:activity_id] => [:environment]  do |t,args|
    id       = args[:activity_id]
    json_str = ""
    File.open("activity_#{id}.json", "r") do |io|
      json_str = io.read
    end
    ha = JSON.parse(json_str)
    a = Activity.from_hash(ha)
    a.save
    puts a.id
  end


end
