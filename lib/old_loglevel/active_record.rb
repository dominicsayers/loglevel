# ActiveRecord-specific settings
class Loglevel
  module ActiveRecord
    private

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
      puts 'Setting ActiveRecord to log only FATAL messages' # debug
      ::ActiveRecord::Base.logger.level = Loglevel::FATAL
      puts "Level: #{::ActiveRecord::Base.logger.level}" # debug
    end
  end
end
