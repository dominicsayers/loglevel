require 'loglevel/classes'
require 'loglevel/active_record'
require 'loglevel/http_logger'
require 'loglevel/help'

module Loglevel
  ENV_VAR_LEVEL   = 'LOGLEVEL'.freeze
  ENV_VAR_LOGGER  = 'LOGLEVEL_LOGGER'.freeze
  ENV_VAR_DEVICE  = 'LOGLEVEL_DEVICE'.freeze
  ENV_VAR_CLASSES = 'LOGLEVEL_CLASSES'.freeze
  LOG_LEVELS = %w(DEBUG INFO WARN ERROR FATAL UNKNOWN).freeze

  class << self
    attr_reader :classes
    attr_writer :logger

    def setup
      return unless ENV[ENV_VAR_LEVEL]

      @classes = Loglevel::Classes.new.classes
      @settings = nil
      @logger = nil
      @log_level = nil

      setup_active_record
      setup_http_logger
      setup_remaining_classes

      help if help?
    end

    def logger
      @logger ||= logger_class.new log_device
    end

    def log_level
      @log_level ||= logger_class.const_get log_level_name
    end

    private

    include Loglevel::ActiveRecord
    include Loglevel::HttpLogger
    include Loglevel::Help

    # Setup any other classes (e.g. Rails)
    def setup_remaining_classes
      classes.each do |klass|
        klass.logger = logger
        klass.logger.level = log_level
      end
    end

    def log_level_name
      (LOG_LEVELS & settings).first || 'INFO'
    end

    def logger_class
      Object.const_get ENV.fetch(ENV_VAR_LOGGER, 'Logger')
    end

    def log_device
      %w(STDOUT STDERR).include?(log_device_name) ? Object.const_get(log_device_name) : log_device_name
    end

    def log_device_name
      ENV.fetch(ENV_VAR_DEVICE, 'STDOUT')
    end

    # Implementing as a method in case someone wants to detect the OS and make
    # an OS-dependent null device
    def null_device
      @null_device ||= '/dev/null'
    end

    def null_logger
      @null_logger ||= logger_class.new null_device
    end

    def settings
      @settings ||= ENV.fetch(ENV_VAR_LEVEL, '').upcase.split(',')
    end

    def lookup(setting)
      settings.include?(setting)
    end
  end
end

Loglevel.setup
