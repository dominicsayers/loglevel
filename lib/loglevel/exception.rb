module Loglevel
  # Local exception classes to make handling exceptions easier
  class Exception < RuntimeError
    UnknownLoggableClass = Class.new(self)
    UnknownLoggerClass = Class.new(self)
    ClassNotLoggable = Class.new(self)
  end
end
