require 'loglevel/settings'

module Loglevel
  class LoggableClass
    class Level
      def value
        @value ||= Loglevel.const_get level_name
      end

      def level_name
        @level_name ||= http_level_name || active_record_level_name || environment_level_name
      end

      private

      extend Forwardable

      def_delegators :logger_name, :klass, :rails?, :active_record?, :http?

      attr_reader :logger_name

      def initialize(logger_name)
        @logger_name = logger_name
      end

      def http_level_name
        @http_level_name ||= 'FATAL' if logger_name.http? && !Loglevel::Settings.http?
      end

      def active_record_level_name
        @active_record_level_name ||= 'FATAL' if logger_name.active_record? && !Loglevel::Settings.active_record?
      end

      def environment_level_name
        @environment_level_name ||= Loglevel::Settings.level
      end
    end
  end
end
