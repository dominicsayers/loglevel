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

      def_delegators :loggable_class, :active_record?, :http?

      attr_reader :loggable_class

      def initialize(loggable_class, settings = nil)
        @loggable_class = loggable_class
        @settings = settings
      end

      def http_level_name
        @http_level_name ||= 'FATAL' if loggable_class.http? && !settings.http?
      end

      def active_record_level_name
        @active_record_level_name ||= 'FATAL' if loggable_class.active_record? && !settings.active_record?
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
