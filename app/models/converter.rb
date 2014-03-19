class ConvertError < StandardError
  def initialize(msg)
    @msg = msg
  end
  def to_s
    "Converter erorr:\n#{@msg}"
  end
end

# Dummy class to wrap external json conversion process
# in this first instance we are just shelling out to cat.
class Converter
  DefaultConverterPath = File.join(Rails.root,'node_modules','smartgraphs-generator','bin','sg-convert')
  attr_accessor :converter_call, :error, :error_msg, :output, :input

  # initialize(path to binary, array of CLI args)
  def initialize(call=DefaultConverterPath)
    self.converter_call = call 
  end

  # convert(string)
  # shell out through process pipe and return STDOUT of
  # process
  def convert(string)
    self.input= string
    retval = "{}"
    self.error = nil
    begin
      IO.popen(self.converter_call, 'r+', :err=>[:child, :out]) do |pipe|
        pipe.puts(string)
        pipe.close_write
        retval= pipe.read
      end
      if call_had_error? 
        raise ConvertError.new(retval)
      end
      self.output = retval.chomp
    rescue Exception => e
      add_error(e)
    end
    return self
  end

  def has_errors?
    return ! self.error.nil?
  end

  private
  def call_had_error?
    return (! $CHILD_STATUS.success?)
  end
  def add_error(e)
    self.error = e
    self.error_msg = "#{e} - #{e.message}"
  end
end
