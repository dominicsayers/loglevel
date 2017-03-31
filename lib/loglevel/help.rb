# Help
class Loglevel
  module Help
    def help
      logger.info <<-HELP.gsub('        ', '')
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

    def inspect
      "#<#{self.class}: logger=#{logger_class}, device=#{device_name}, level=#{level_name}, settings=#{settings}>"
    end

    def debug
      debug = classes.map do |klass|
        l = klass.logger
        d = l.instance_variable_get('@logdev')
        f = d.filename || d.dev || 'nil'
        v = self.class::LOGLEVELS[l.level]
        "#{klass}: logger=#{l.class}, device=#{f}, level=#{v}"
      end

      debug.join("\n")
    end

    private

    def help?
      lookup('HELP') || settings == ['TRUE']
    end
  end
end
