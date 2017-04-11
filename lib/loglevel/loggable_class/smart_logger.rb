module Loglevel
  class LoggableClass
    class SmartLogger
      class << self
        def create
          enhanced_logger || simple_logger
        end

        private

        def simple_logger
          @simple_logger ||= logger_class.new Loglevel.device
        end

        def enhanced_logger
          ActiveSupport::TaggedLogging.new(simple_logger) if defined?(ActiveSupport::TaggedLogging)
        end

        def logger_class
          @logger_class ||= Object.const_get logger_class_name
        rescue NameError => e
          raise e unless e.message =~ /.+constant.+#{logger_class_name.split(Loglevel::SRO).first}/
          raise Loglevel::Exception::UnknownLoggerClass, logger_class_name
        end

        def logger_class_name
          @logger_class_name ||= environment_logger_class_name || rails_logger_class_name || 'Logger'
        end

        def environment_logger_class_name
          @environment_logger_class_name ||= ENV[Loglevel::ENV_VAR_LOGGER]
        end

        def rails_logger_class_name
          'ActiveSupport::Logger' if defined?(ActiveSupport::Logger)
        end
      end
    end
  end
end
