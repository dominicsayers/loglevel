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

      def_delegators :loggable_name, :klass, :rails?, :active_record?, :http?

      attr_reader :loggable_name

      def initialize(loggable_name, settings = nil)
        @loggable_name = loggable_name
        @settings = settings
      end

      def http_level_name
        @http_level_name ||= 'FATAL' if loggable_name.http? && !settings.http?
      end

      def active_record_level_name
        @active_record_level_name ||= 'FATAL' if loggable_name.active_record? && !settings.active_record?
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
