class Loglevel
  # Local exception classes to make handling exceptions easier
  class Exception < RuntimeError
    BadLoggerClass = Class.new(self)
  end
end
