require 'loglevel/loggable_class/level'
require 'loglevel/loggable_class/smart_logger'

module Loglevel
  class LoggableClass
    attr_reader :class_name, :logger
    alias to_s class_name

    def setup
      self.logger = smart_logger.create
      logger.level = level.value
      klass.logger = logger
      additional_http_setup
    end

    def level
      @level ||= Level.new(self)
    end

    def active_record?
      @active_record ||= canonical_name == '::ActiveRecord::Base'
    end

    def http?
      @http ||= canonical_name == '::HttpLogger'
    end

    private

    attr_writer :logger

    def initialize(class_name)
      @class_name = class_name
      raise Loglevel::Exception::ClassNotLoggable, class_name unless klass.respond_to?(:logger=)
    end

    def additional_http_setup
      return unless http?

      klass.level = level.level_name.downcase.to_sym
      klass.log_response_body = settings.response_body?
      klass.log_headers = settings.request_headers?
      klass.ignore = [/9200/, /7474/] # ignore Elasticsearch & Neo4J
    end

    def klass
      @klass ||= Object.const_get(canonical_name)
    rescue NameError => exception
      handle_unloggable_class(exception)
    end

    def canonical_name
      @canonical_name ||= class_name[0, 2] == Loglevel::SRO ? class_name : "#{Loglevel::SRO}#{class_name}"
    end

    def settings
      @settings ||= Loglevel::Settings.clone # More testable
    end

    def smart_logger
      @smart_logger ||= SmartLogger.clone # More testable
    end

    def handle_unloggable_class(exception)
      raise exception unless  exception.class == NameError &&
                              class_name.respond_to?(:split) &&
                              exception.message =~ /.+constant.+#{class_name.split(Loglevel::SRO).first}/

      raise Loglevel::Exception::UnknownLoggableClass, class_name
    end
  end
end
