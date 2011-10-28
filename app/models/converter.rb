# Dummy class to wrap external json conversion process
# in this first instance we are just shelling out to cat.
class Converter
    attr_accessor :converter_call

  # initialize(path to binary, array of CLI args)
  def initialize(path=File.join('/','bin','cat'),args=[])
    self.converter_call = [path] + args
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
