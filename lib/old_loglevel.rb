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
    @logger ||= use_default_logger? ? default_logger : logger_class.new(device)
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
      klass.logger = logger.dup
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
    use_default_logger? ? default_logger.class : Object.const_get(logger_class_name)
  rescue NameError
    raise Loglevel::Exception::BadLoggerClass, "Can't find logger class #{logger_class_name} - have you required it?"
  end

  def logger_class_name
    @logger_class_name ||= ENV.fetch(ENV_VAR_LOGGER, logger_class_name_default)
  end

  def logger_class_name_default
    @logger_class_default ||= if default_logger.nil? || default_logger_not_instantiatable?
                                'Logger'
                              else
                                default_logger.class.name
                              end
  end

  def default_logger_not_instantiatable?
    defined?(ActiveSupport::TaggedLogging) && default_logger.is_a?(ActiveSupport::TaggedLogging)
  end

  def use_default_logger?
    !ENV[ENV_VAR_LOGGER] && !ENV[ENV_VAR_DEVICE] && !default_logger.nil?
  end

  def default_logger
    @default_logger ||= ::Rails.logger if defined?(::Rails)
  end

  def device
    %w[STDOUT STDERR].include?(device_name) ? Object.const_get(device_name) : device_name
  end

  def device_name
    ENV.fetch(ENV_VAR_DEVICE, 'STDOUT')
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
