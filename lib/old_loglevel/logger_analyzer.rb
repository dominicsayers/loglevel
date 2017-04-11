# Analyses the logger method of a class
class Loglevel
  class LoggerAnalyzer
    def level_name
      @level_name ||= Loglevel::LOGLEVELS[level]
    end

    def level
      @level ||= logger_level.is_a?(0.class) ? logger_level : 5
    end

    def logger_level
      @logger_level ||= logger.level
    end

    def device_name
      @device_name ||= logdev.filename || logdev.dev.inspect || 'nil'
    end

    def logdev
      @logdev ||= logger.instance_variable_get('@logdev') || Struct.new(:filename, :dev).new
    end

    def logger_class
      @logger_class ||= logger.class
    end

    def logger
      @logger ||= klass.logger || Struct.new(:level).new(0)
    end

    private

    attr_reader :klass

    def initialize(klass)
      @klass = klass
    end
  end
end
