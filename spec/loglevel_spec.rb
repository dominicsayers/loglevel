require 'logger'

RSpec.describe Loglevel do
  before do
    class MyClass
      class << self
        attr_accessor :logger
      end
    end

    class Rails < MyClass; end

    module ActiveRecord
      class Base < Rails; end
    end

    class HttpLogger < Rails
      class << self
        attr_accessor :level, :log_response_body, :log_headers, :ignore
      end
    end
  end

  after do
    Object.send(:remove_const, :MyClass)
    Object.send(:remove_const, :Rails)
    Object.send(:remove_const, :ActiveRecord)
    Object.send(:remove_const, :HttpLogger)
  end

  context 'no environment variable' do
    before { Loglevel.setup }

    it 'has the expected logger class' do
      expect(Loglevel.send(:logger_class)).to eq Loglevel.send(:logger_class)
    end

    it 'has the expected device' do
      expect(Loglevel.send(:log_device)).to eq STDOUT
    end

    it 'has the expected log level' do
      expect(Rails.logger).to be_nil
    end

    it 'has the expected ActiveRecord::Base settings' do
      expect(::ActiveRecord::Base.logger).to be_nil
    end

    it 'has the expected HttpLogger settings' do
      expect(::HttpLogger.level).to be_nil
      expect(::HttpLogger.log_response_body).to be_nil
      expect(::HttpLogger.log_headers).to be_nil
      expect(::HttpLogger.ignore).to be_nil
    end
  end

  context 'defaults' do
    before do
      ENV.store Loglevel::ENV_VAR_LEVEL, 'INFO'
      Loglevel.setup
    end

    after { ENV.delete Loglevel::ENV_VAR_LEVEL }

    it 'has the expected logger class' do
      expect(Loglevel.send(:logger_class)).to eq ::Logger
    end

    it 'has the expected device' do
      expect(Loglevel.send(:log_device)).to eq STDOUT
    end

    it 'has the expected log level' do
      expect(Rails.logger).to eq Loglevel.logger
      expect(Rails.logger.level).to eq Logger.const_get('INFO')
    end

    it 'has the expected ActiveRecord::Base settings' do
      expect(::ActiveRecord::Base.logger).to eq Loglevel.logger
      expect(::ActiveRecord::Base.logger.level).to eq Logger.const_get('INFO')
    end

    it 'has the expected HttpLogger settings' do
      expect(::HttpLogger.level).to eq :info
      expect(::HttpLogger.log_response_body).to be_truthy
      expect(::HttpLogger.log_headers).to be_truthy
      expect(::HttpLogger.ignore).to include(/9200/, /7474/)
    end
  end

  context 'variations' do
    before do
      class MyLogger
        INFO = 1
        WARN = 2
        FATAL = 4
        attr_accessor :level
        def initialize(device); end
      end

      ENV.store Loglevel::ENV_VAR_LOGGER, 'MyLogger'
      ENV.store Loglevel::ENV_VAR_DEVICE, 'STDERR'
    end

    after do
      ENV.delete Loglevel::ENV_VAR_LEVEL
      ENV.delete Loglevel::ENV_VAR_LOGGER
      ENV.delete Loglevel::ENV_VAR_DEVICE
      Object.send(:remove_const, :MyLogger)
    end

    context 'HTTP and ActiveRecord' do
      before do
        ENV.store Loglevel::ENV_VAR_LEVEL, 'WARN'
        Loglevel.setup
      end

      after do
        ENV.delete Loglevel::ENV_VAR_LEVEL
      end

      it 'has the expected logger class' do
        expect(Loglevel.send(:logger_class)).to eq ::MyLogger
      end

      it 'has the expected device' do
        expect(Loglevel.send(:log_device)).to eq STDERR
      end

      it 'has the expected log level' do
        expect(Rails.logger).to eq Loglevel.logger
        expect(Rails.logger.level).to eq Logger.const_get('WARN')
      end
    end

    context 'HTTP but not ActiveRecord' do
      before do
        ENV.store Loglevel::ENV_VAR_LEVEL, 'WARN,NOBODY,NOHEADERS,NOAR'
        Loglevel.setup
      end

      after do
        ENV.delete Loglevel::ENV_VAR_LEVEL
      end

      it 'has the expected ActiveRecord::Base settings' do
        expect(::ActiveRecord::Base.logger).to eq Loglevel.send(:null_logger)
      end

      it 'has the expected HttpLogger settings' do
        expect(::HttpLogger.level).to eq :warn
        expect(::HttpLogger.log_response_body).to be_falsey
        expect(::HttpLogger.log_headers).to be_falsey
        expect(::HttpLogger.ignore).to include(/9200/, /7474/)
      end
    end

    context 'ActiveRecord but not HTTP' do
      before do
        ENV.store Loglevel::ENV_VAR_LEVEL, 'WARN,NOHTTP'
        Loglevel.setup
      end

      after do
        ENV.delete Loglevel::ENV_VAR_LEVEL
      end

      it 'has the expected ActiveRecord::Base settings' do
        expect(::ActiveRecord::Base.logger).to eq Loglevel.logger
        expect(::ActiveRecord::Base.logger.level).to eq Logger.const_get('WARN')
      end

      it 'has the expected HttpLogger settings' do
        expect(::HttpLogger.level).to eq :fatal
        expect(::HttpLogger.log_response_body).to be_falsey
        expect(::HttpLogger.log_headers).to be_falsey
        expect(::HttpLogger.ignore).to be_nil
      end
    end
  end
end
