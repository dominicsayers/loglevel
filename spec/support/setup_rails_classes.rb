class SpecLogDevice
  attr_reader :dev

  def initialize(device)
    @dev = device
  end
end

module ActiveSupport
  class Logger
    def initialize(logdev, *_)
      @logdev = logdev
    end
  end

  class TaggedLogging
    WARN = 2
    FATAL = 4
    attr_accessor :level

    def initialize(logger, *_)
      @logger = logger
      self.level = WARN
    end

    def info(*_); end
  end
end

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
  class Base
    class << self
      include SpecLoggable
    end
  end
end

module HttpLogger
  class << self
    include SpecLoggable
    attr_accessor :log_response_body, :log_headers, :ignore

    def level
      LEVELS[logger.level]
    end

    def level=(value)
      logger.level = LEVELS.index(value)
    end

    LEVELS = %i[debug info warn error fatal unknown].freeze
  end
end
