require 'loglevel/loggable_class'

module Loglevel
  module LoggableClasses
    class << self
      extend Forwardable

      def_delegators :classes, :each, :map, :length

      def classes
        puts "Getting classes. class_names == #{class_names}" # debug
        @classes ||= class_names.map { |class_name| class_from_name(class_name) }.compact
      end

      private

      RAILS_LOGGABLE_CLASSES = %w[Rails ActiveRecord::Base HttpLogger].freeze

      def class_names
        @class_names ||= environment_class_names | RAILS_LOGGABLE_CLASSES
      end

      def environment_class_names
        @environment_class_names ||= ENV.fetch(Loglevel::ENV_VAR_CLASSES, '').gsub(/[[:space:]]/, '').split(',')
      end

      def class_from_name(class_name)
        LoggableClass.new class_name
      rescue Loglevel::Exception
        nil
      end
    end
  end
end
