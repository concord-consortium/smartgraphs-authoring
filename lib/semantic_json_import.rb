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
  
  def self.load_dir(dir_name)
    Dir.new(json_directory).each do |fname|
      activity = new(fname).load
    end
  end

  # def load_mem(filename)
  #   json_str = load_json(filename)
  #   ha = JSON.parse(json_str)
  #   Activity.from_hash_mem(ha)
  # end

  def load
    ha = JSON.parse(json)
    @activity = Activity.from_hash(ha)
    self
  end

  def to_hash
    # HashWithIndifferentAccess.new(load_mem(filename).create_hash)
    hash = @activity.create_hash
    HashWithIndifferentAccess.new(hash)
  end
end

