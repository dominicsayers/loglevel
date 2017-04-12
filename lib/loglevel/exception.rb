module Loglevel
  # Local exception classes to make handling exceptions easier
  class Exception < RuntimeError
    UnknownLoggableClass = Class.new(self)
    UnknownLoggerClass = Class.new(self)
    ClassNotLoggable = Class.new(self)

    def self.handle_bad_class(class_name, exception, exception_class)
      raise exception unless  exception.class == NameError &&
                              class_name.respond_to?(:split) &&
                              exception.message =~ /.+constant.+#{class_name.split(Loglevel::SRO).first}/

      raise exception_class, class_name
    end
  end
end
