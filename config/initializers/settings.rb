if File.exists?("#{Rails.root}/config/settings.yml")
  c = YAML::load(File.open("#{Rails.root}/config/settings.yml"))
  if(c[:append_path])
    ENV['PATH'] = "#{ENV['PATH']}:#{c[:append_path]}"
  end
end
