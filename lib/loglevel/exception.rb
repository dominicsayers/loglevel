module Loglevel
  # Local exception classes to make handling exceptions easier
  class Exception < RuntimeError
    # We've been asked to setting up logging for an unknown class
    UnknownLoggableClass = Class.new(self)
    # We can't instantiate the defined logger class
    UnknownLoggerClass = Class.new(self)
    # The class we've been asked to set up logging for doesn't understand
    # logging
    ClassNotLoggable = Class.new(self)

    def self.handle_bad_class(class_name, exception, exception_class)
      raise exception unless exception.class == NameError && exception.message =~ /.+constant.+/
      raise exception_class, class_name
    end
  end
end
