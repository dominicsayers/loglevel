require 'loglevel/loggable_class/level'
require 'loglevel/loggable_class/smart_logger'

module Loglevel
  # An instance of a class that can be logged, i.e. has a #logger and a #logger=
  # method
  class LoggableClass
    attr_reader :class_name, :logger
    alias to_s class_name

    def check
      # No checks implemented yet
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

    def debug
      { name: class_name, logger: logger.class, level: level.level_name }
    end

    private

    attr_writer :logger

    def initialize(class_name)
      @class_name = class_name
      self.logger = smart_logger
      logger.level = level.value
      klass.logger = logger
      additional_http_setup
    rescue NoMethodError => exception
      raise unless exception.message =~ /undefined method `logger='/
      raise Loglevel::Exception::ClassNotLoggable, class_name
    end

    def additional_http_setup
      return unless http?

      klass.level = level.level_name.downcase.to_sym
      klass.log_response_body = settings.response_body?
      klass.log_headers = settings.request_headers?
      klass.ignore = [/9200/, /7474/] # ignore Elasticsearch & Neo4J
    end

    def klass
      @klass ||= canonical_name.to_class Loglevel::Exception::UnknownLoggableClass
    end

    def canonical_name
      @canonical_name ||= Loglevel::Name.new(
        class_name[0, 2] == Loglevel::SRO ? class_name : "#{Loglevel::SRO}#{class_name}"
      )
    end

    def settings
      @settings ||= Loglevel::Settings.clone # More testable
    end

    def smart_logger
      @smart_logger ||= SmartLogger.clone.create # More testable
    end
  end
end
