module Loglevel
  class LoggableClass
    class Name
      def klass
        puts "class_name: #{class_name}, canonical_name: #{canonical_name}" # debug
        @klass ||= Object.const_get(canonical_name)
      rescue NameError => e
        raise e unless e.message =~ /.+constant.+#{class_name.split(Loglevel::SRO).first}/
        raise Loglevel::Exception::UnknownLoggableClass, class_name
      end

      attr_reader :class_name
      alias to_s class_name

      def rails?
        @rails ||= canonical_name == '::Rails'
      end

      def active_record?
        @active_record ||= canonical_name == '::ActiveRecord::Base'
      end

      def http?
        @http ||= canonical_name == '::HttpLogger'
      end

      private

      def initialize(class_name)
        @class_name = class_name
      end

      def canonical_name
        @canonical_name ||= class_name[0, 2] == Loglevel::SRO ? class_name : "#{Loglevel::SRO}#{class_name}"
      end
    end
  end
end
