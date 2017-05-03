# Fake Logger for testing
class Logger
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
