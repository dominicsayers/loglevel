require 'loglevel/loggable_class/name'
require 'loglevel/loggable_class/level'
require 'loglevel/loggable_class/smart_logger'

module Loglevel
  class LoggableClass
    attr_accessor :name, :logger

    def setup
      self.logger = SmartLogger.create
      logger.level = level.value
    end

    def level
      @level ||= Level.new(name)
    end

    private

    def initialize(class_name)
      @name = Name.new(class_name)
      raise Loglevel::Exception::ClassNotLoggable, class_name unless name.klass.respond_to?(:logger=)
    end
  end
end
