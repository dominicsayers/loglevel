# These classes mimic the state when Loglevel is initialized in a script in
# config\initializers in a Rails app. We also include the HttpLogger class.
class MyLogDevice
  attr_reader :filename, :dev

  def initialize(device)
    @dev = device
  end
end

class MyDefaultLogger
  WARN = 2
  FATAL = 4
  attr_accessor :level

  def initialize(device)
    @logdev = MyLogDevice.new(device)
    @level = WARN
  end

  def info(*_); end
end

module MyClass
  def logger
    @logger ||= MyDefaultLogger.new(STDOUT)
  end

  def logger=(value)
    @logger = value
  end
end

module Rails
  class << self
    include MyClass
  end
end

module HttpLogger
  class << self
    include MyClass
    attr_accessor :log_response_body, :log_headers, :ignore

    def level
      LEVELS[logger.level]
    end

    def level=(value)
      logger.level = LEVELS.index(value)
    end

    LEVELS = %i[debug info warn error fatal unknown]
  end
end

module ActiveRecord
  class Base
    class << self
      include MyClass
    end
  end
end
