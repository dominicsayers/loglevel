require 'loglevel/exception'
require 'loglevel/constants'
require 'loglevel/loggable_classes'

module Loglevel
  extend self

  def setup
    loggable_classes.each(&:setup)
  end

  def debug
    loggable_classes.map { |c| { name: c.name.to_s, logger: c.logger.class, level: c.level.level_name } }
  end

  def device
    @device ||= ENV.fetch Loglevel::ENV_VAR_DEVICE, STDOUT
  end

  def loggable_classes
    LoggableClasses.clone # For testing
  end
end
