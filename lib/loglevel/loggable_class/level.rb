require 'loglevel/settings'

module Loglevel
  class LoggableClass
    # The current log level
    class Level
      def value
        @value ||= Loglevel.const_get level_name
      end

      def level_name
        @level_name ||= http_level_name || active_record_level_name || environment_level_name
      end

      private

      extend Forwardable

      def_delegators :@loggable_class, :active_record?, :http?

      def initialize(loggable_class, settings = nil)
        @loggable_class = loggable_class
        @settings = settings
      end

      def http_level_name
        @http_level_name ||= 'FATAL' if http? && !settings.http?
      end

      def active_record_level_name
        @active_record_level_name ||= 'FATAL' if active_record? && !settings.active_record?
      end

      def environment_level_name
        @environment_level_name ||= settings.level
      end

      def settings
        @settings ||= Loglevel::Settings.clone # More testable
      end
    end
  end
end
