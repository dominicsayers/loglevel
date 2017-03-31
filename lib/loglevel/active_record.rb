# ActiveRecord-specific settings
class Loglevel
  module ActiveRecord
    def active_record?
      !lookup('NOAR')
    end

    def setup_active_record
      return unless defined?(::ActiveRecord::Base) && @classes_to_setup.delete(::ActiveRecord::Base)
      active_record? ? setup_active_record_logger_to_log : setup_active_record_logger_not_to_log
    end

    def setup_active_record_logger_to_log
      ::ActiveRecord::Base.logger = logger
      ::ActiveRecord::Base.logger.level = level
    end

    def setup_active_record_logger_not_to_log
      ::ActiveRecord::Base.logger = null_logger
      ::ActiveRecord::Base.logger.level = logger_class::FATAL
    end
  end
end
