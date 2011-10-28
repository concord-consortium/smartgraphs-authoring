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
    IO.popen(self.converter_call, 'r+') do |pipe|
      pipe.puts(string)
      pipe.close_write
      return pipe.read.chomp
    end
  end
end
