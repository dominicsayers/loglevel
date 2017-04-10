require 'loglevel/exception'
require 'loglevel/classes'
require 'loglevel/active_record'
require 'loglevel/http_logger'
require 'loglevel/help'
require 'loglevel/logger_analyzer'

class Loglevel
  ENV_VAR_LEVEL   = 'LOGLEVEL'.freeze
  ENV_VAR_LOGGER  = 'LOGLEVEL_LOGGER'.freeze
  ENV_VAR_DEVICE  = 'LOGLEVEL_DEVICE'.freeze
  ENV_VAR_CLASSES = 'LOGLEVEL_CLASSES'.freeze
  LOGLEVELS = %w[DEBUG INFO WARN ERROR FATAL UNKNOWN].freeze

  LOGLEVELS.each_with_index { |k, v| const_set(k, v) }

  class << self
    def setup
      new.setup
    end

    def inspect
      new.inspect
    end

    def debug
      new.debug
    end
  end

  attr_reader :classes
  attr_writer :logger

  def logger
    @logger ||= logger_class.new device
  end

  def level
    @level ||= self.class.const_get level_name
  end

  def setup
    return self unless ENV[ENV_VAR_LEVEL]

    @settings = nil
    @logger = nil
    @level = nil

    setup_classes
    announce
    self
  end

  private

  def initialize
    @classes = Loglevel::Classes.new.classes
  end

  def setup_classes
    @classes_to_setup = @classes.dup
    setup_active_record
    setup_http_logger
    setup_remaining_classes
  end

  # Setup any other classes (e.g. Rails)
  def setup_remaining_classes
    @classes_to_setup.each do |klass|
      klass.logger = logger
      klass.logger.level = level
    end
  end

  def announce
    help if help?
    puts inspect if level_name == 'DEBUG'
    puts debug if lookup('__DEBUG')
  end

  def level_name
    (LOGLEVELS & settings).first || 'WARN'
  end

  def logger_class
    Object.const_get logger_class_name
  rescue NameError
    raise Loglevel::Exception::BadLoggerClass, "Can't find logger class #{logger_class_name} - have you required it?"
  end

  def logger_class_name
    @logger_class_name ||= ENV.fetch(ENV_VAR_LOGGER, logger_class_name_default)
  end

  def logger_class_name_default
    @logger_class_default ||= defined?(::Rails) && ::Rails.logger ? ::Rails.logger.class.name : 'Logger'
  end

  def device
    %w[STDOUT STDERR].include?(device_name) ? Object.const_get(device_name) : device_name
  end

  def device_name
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

  def lookup(setting)
    settings.include?(setting)
  end

  def settings
    @settings ||= ENV.fetch(ENV_VAR_LEVEL, '').upcase.split(',')
  end

  include Loglevel::ActiveRecord
  include Loglevel::HttpLogger
  include Loglevel::Help
end
