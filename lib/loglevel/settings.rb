module Loglevel
  # Parses the environment variable into usable settings
  module Settings
    extend self

    def level
      @level ||= (Loglevel::LOGLEVELS & settings).first || 'WARN'
    end

    def http?
      !lookup('NOHTTP')
    end

    def active_record?
      !lookup('NOAR')
    end

    def response_body?
      !lookup('NOBODY')
    end

    def request_headers?
      !lookup('NOHEADERS')
    end

    def inspect
      "#<Loglevel::Settings #{settings}>"
    end

    private

    def lookup(setting)
      settings.include?(setting)
    end

    def settings
      @settings ||= ENV.fetch(ENV_VAR_LEVEL, '').upcase.split(',')
    end
  end
end
