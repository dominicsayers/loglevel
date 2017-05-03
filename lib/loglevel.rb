require 'loglevel/exception'
require 'loglevel/constants'
require 'loglevel/loggable_classes'

# Sets up any loggable classes to the log level you specify in an environment
# variable
module Loglevel
  extend self

  def setup
    loggable_classes.each(&:check)
  end

  def debug
    loggable_classes.map(&:debug)
  end

  def device
    @device ||= ENV.fetch Loglevel::ENV_VAR_DEVICE, STDOUT
  end

  def loggable_classes
    @loggable_classes ||= LoggableClasses.clone # More testable
  end
end
