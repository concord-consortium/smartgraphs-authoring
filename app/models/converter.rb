require 'open3'
class ConvertError < StandardError
  def initialize(msg)
    @msg = msg
  end
  def to_s
    @msg
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
  # shell out through process pipe and read STDOUT & STDERR 
  # of process
  def convert(string)
    self.input= string
    retval = nil
    self.error = nil
    error_msgs = ""
    self.output = ""
    begin
      Open3.popen3(self.converter_call) do |stdin, stdout, stderr, wait_thr|
        stdin.puts(string)
        stdin.close
        stderr.each_line { |line| error_msgs << line }
        stdout.each_line { |line| self.output << line }
        retval = wait_thr.value
      end
      if (!retval.success?)
        if error_msgs.match(/^Error:/)
          error_msgs = error_msgs.scan(/^Error:(.*)$/).flatten.join(" ")
        end
        raise ConvertError.new(error_msgs)
      end
    rescue Exception => e
      add_error(e)
    end
    return self
  end

  def has_errors?
    return ! self.error.nil?
  end

  private
  def add_error(e)
    self.error = e
    self.error_msg = "#{e} - #{e.message}"
  end
end
