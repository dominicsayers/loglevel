module Loglevel
  class LoggableClass
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
          @logger_class ||= Object.const_get class_name
        rescue NameError => exception
          handle_unknown_class(exception)
        end

        def class_name
          @class_name ||= environment_class_name || rails_class_name || 'Logger'
        end

        def environment_class_name
          @environment_class_name ||= ENV[Loglevel::ENV_VAR_LOGGER]
        end

        def rails_class_name
          'ActiveSupport::Logger' if defined?(ActiveSupport::Logger)
        end

        def device
          @device ||= Loglevel.clone.device # More testable
        end

        def handle_unknown_class(exception)
          raise exception unless  exception.class == NameError &&
                                  class_name.respond_to?(:split) &&
                                  exception.message =~ /.+constant.+#{class_name.split(Loglevel::SRO).first}/

          raise Loglevel::Exception::UnknownLoggerClass, class_name
        end
      end
    end
  end
end
