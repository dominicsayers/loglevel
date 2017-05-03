module Loglevel
  class LoggableClass
    # The most appropriate logging class for this environment
    class SmartLogger
      class << self
        def create
          enhanced_logger || simple_logger
        end

        private

        def simple_logger
          logger_class.new device
        end

        def enhanced_logger
          ActiveSupport::TaggedLogging.new(simple_logger) if defined?(ActiveSupport::TaggedLogging)
        end

        def logger_class
          @logger_class ||= class_name.to_class Loglevel::Exception::UnknownLoggerClass
        end

        def class_name
          @class_name ||= Loglevel::Name.new(environment_class_name || rails_class_name || 'Logger')
        end

        def environment_class_name
          @environment_class_name ||= ENV[Loglevel::ENV_VAR_LOGGER]
        end

        def rails_class_name
          'ActiveSupport::Logger' if defined?(ActiveSupport::Logger)
        end

        def device
          @device ||= loglevel.device
        end

        def loglevel
          @loglevel ||= Loglevel.clone # More testable
        end
      end
    end
  end
end
