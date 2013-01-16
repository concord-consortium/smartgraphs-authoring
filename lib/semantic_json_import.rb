class SemanticJSONImport
  attr_accessor :directory, :json, :file_path

  def initialize(filename)
    @file_path = "#{directory}/#{filename}"
  end

  def directory
    @directory ||= "#{Rails.root}/features/expected-output"
  end

  def json
    @json ||= File.open(file_path, "r") do |io|
      io.read
    end
  end
  
  def self.load_dir(dir_name, save = false)
    Dir.new(json_directory).each do |fname|
      activity = save ? new(fname).load : new(fname).load_and_save
    end
  end

  def load_and_save
    ha = JSON.parse(json)
    @activity = Activity.from_hash(ha)
    self
  end

  def load
    ha = JSON.parse(json)
    @activity = Activity.from_hash_to_mem(ha)
    self
  end

  def to_hash
    hash = @activity.create_hash
    HashWithIndifferentAccess.new(hash)
  end
end

