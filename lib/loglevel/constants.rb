module Loglevel
  LOGLEVELS = %w[DEBUG INFO WARN ERROR FATAL UNKNOWN].freeze
  LOGLEVELS.each_with_index { |k, v| const_set(k, v) }

  ENV_VAR_LEVEL   = 'LOGLEVEL'.freeze
  ENV_VAR_LOGGER  = 'LOGLEVEL_LOGGER'.freeze
  ENV_VAR_DEVICE  = 'LOGLEVEL_DEVICE'.freeze
  ENV_VAR_CLASSES = 'LOGLEVEL_CLASSES'.freeze

  SCOPE_RESOLUTION_OPERATOR = SRO = '::'.freeze
end
