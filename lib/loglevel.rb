require 'loglevel/exception'
require 'loglevel/constants'
require 'loglevel/loggable_classes'

module Loglevel
  extend self

  def setup
    loggable_classes.each(&:setup)
  end

  def debug
    loggable_classes.map { |c| { name: c.class_name, logger: c.logger.class, level: c.level.level_name } }
  end

  def device
    @device ||= ENV.fetch Loglevel::ENV_VAR_DEVICE, STDOUT
  end

  def loggable_classes
    @loggable_classes ||= LoggableClasses.clone # More testable
  end

  def name_to_class(class_name, exception_class)
    Object.const_get(class_name)
  rescue NameError => exception
    Loglevel::Exception.handle_bad_class(class_name, exception, exception_class)
  end
end
