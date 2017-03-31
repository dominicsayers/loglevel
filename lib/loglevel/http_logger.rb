# HttpLogger-specific settings
class Loglevel
  module HttpLogger
    private

    def http?
      !lookup('NOHTTP')
    end

    def response_body?
      !lookup('NOBODY')
    end

    def request_headers?
      !lookup('NOHEADERS')
    end

    def setup_http_logger
      return unless defined?(::HttpLogger) && @classes_to_setup.delete(::HttpLogger)
      http? ? setup_http_logger_to_log : setup_http_logger_not_to_log
    end

    def setup_http_logger_to_log
      ::HttpLogger.logger = logger
      ::HttpLogger.level = level_name.downcase.to_sym
      ::HttpLogger.log_response_body = response_body?
      ::HttpLogger.log_headers = request_headers?
      ::HttpLogger.ignore = [/9200/, /7474/] # ignore Elasticsearch & Neo4J
    end

    def setup_http_logger_not_to_log
      ::HttpLogger.logger = null_logger
      ::HttpLogger.level = :fatal
    end
  end
end
