# Fake LogDevice for testing
class SpecLogDevice
  attr_reader :dev

  def initialize(device)
    @dev = device
  end
end

module ActiveSupport
  # Fake Logger for testing
  class Logger
    def initialize(logdev, *_)
      @logdev = logdev
    end
  end

  # Fake TaggedLogging for testing
  class TaggedLogging
    WARN = 2
    FATAL = 4
    attr_reader :level

    def initialize(logger, *_)
      @logger = logger
      self.level = WARN
    end

    def info(*_); end

    def level=(value)
      @level = value if value.is_a?(0.class)
    end
  end
end

# Loggable classes for testing
module SpecLoggable
  def logger
    @logger ||= ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new(SpecLogDevice.new(STDOUT)))
  end

  def logger=(value)
    @logger = value
  end
end

module Rails
  class << self
    include SpecLoggable
  end
end

module ActiveRecord
  # Fake ActiveRecord::Base for testing
  class Base
    class << self
      include SpecLoggable
    end
  end
end

# Fake HttpLogger for testing
module HttpLogger
  class << self
    include SpecLoggable
    attr_reader :log_response_body, :log_headers, :ignore

    def level
      LEVELS[logger.level]
    end

    def level=(value)
      logger.level = LEVELS.index(value)
    end

    def log_response_body=(value)
      puts "#{value} (#{value.class})" # debug
      @log_response_body = value if [true, false].include?(value)
    end

    def log_headers=(value)
      @log_headers = value if [true, false].include?(value)
    end

    def ignore=(value)
      @ignore = value if value.is_a?(Array)
    end

    LEVELS = %i[debug info warn error fatal unknown].freeze
  end
end
