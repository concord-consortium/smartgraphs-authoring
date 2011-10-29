# Dummy class to wrap external json conversion process
# in this first instance we are just shelling out to cat.
class Converter
  attr_accessor :converter_call

  # initialize(path to binary, array of CLI args)
  def initialize(call="/bin/cat")
    self.converter_call = call
  end

  # convert(string)
  # shell out through process pipe and return STDOUT of
  # process
  def convert(string)
    retval = "{}"
    IO.popen(self.converter_call, 'r+', :err=>[:child, :out]) do |pipe|
      begin
        pipe.puts(string)
        pipe.close_write
        pipe.flush
      rescue
        # failed to write but we might still get a useful error
      end
      retval= pipe.read
      pipe.flush
      pipe.close_read
    end
    return retval.chomp
  end
end
