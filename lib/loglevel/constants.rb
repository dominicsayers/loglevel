# :reek:TooManyConstants { max_constants: 7 }
module Loglevel
  LOGLEVELS = %w[DEBUG INFO WARN ERROR FATAL UNKNOWN].freeze
  LOGLEVELS.each_with_index { |key, value| const_set(key, value) }

  ENV_VAR_LEVEL   = 'LOGLEVEL'.freeze
  ENV_VAR_LOGGER  = 'LOGGER'.freeze
  ENV_VAR_DEVICE  = 'LOGDEVICE'.freeze
  ENV_VAR_CLASSES = 'LOGCLASSES'.freeze

  SCOPE_RESOLUTION_OPERATOR = SRO = '::'.freeze
end
