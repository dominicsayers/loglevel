# Help
module Loglevel
  module Help
    def help?
      lookup('HELP') || settings == ['TRUE']
    end

    def help
      logger.info <<-HELP
        Usage: DEBUG=SETTING,SETTING,SETTING rails server

        Available settings are as follows:
        HELP      Show these options
        FATAL     Equivalent to config.log_level = :fatal
        ERROR     Equivalent to config.log_level = :error
        WARN      Equivalent to config.log_level = :warn
        INFO      Equivalent to config.log_level = :info
        DEBUG     Equivalent to config.log_level = :debug
        NOAR      Do not show ActiveRecord messages
        NOHTTP    Do not show HTTP messages
        NOHEADERS Do not include response headers in HTTP log
        NOBODY    Do not include response body in HTTP log

        HTTP messages will only be shown if http_logger gem is present
      HELP
    end
  end
end
