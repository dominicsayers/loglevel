RSpec.describe Loglevel do
  before(:example) { load 'support/define_rails_classes.rb' }
  after(:example)  { load 'support/teardown_rails_classes.rb' }

  context 'no environment variable' do
    let(:loglevel) { Loglevel.setup }

    it 'has the expected logger class' do
      expect(loglevel.send(:logger_class)).to eq MyDefaultLogger
    end

    it 'has the expected device' do
      expect(loglevel.send(:device)).to eq STDOUT
    end

    it 'has the expected log level' do
      expect(Rails.logger).to be_a MyDefaultLogger
    end

    it 'has the expected ActiveRecord::Base settings' do
      expect(::ActiveRecord::Base.logger).to be_a MyDefaultLogger
    end

    it 'has the expected HttpLogger settings' do
      expect(::HttpLogger.logger).to be_a MyDefaultLogger
      expect(::HttpLogger.level).to eq :warn
      expect(::HttpLogger.log_response_body).to be_nil
      expect(::HttpLogger.log_headers).to be_nil
      expect(::HttpLogger.ignore).to be_nil
    end
  end

  context 'defaults' do
    let(:loglevel) { Loglevel.setup }

    before { ENV.store Loglevel::ENV_VAR_LEVEL, 'HELP' }
    after { ENV.delete Loglevel::ENV_VAR_LEVEL }

    it 'has the expected logger class' do
      expect(loglevel.send(:logger_class)).to eq MyDefaultLogger
    end

    it 'has the expected device' do
      expect(loglevel.send(:device)).to eq STDOUT
    end

    it 'has the expected log level' do
      loglevel # force instantiation
      expect(Rails.logger).to eq loglevel.logger
      expect(Rails.logger.level).to eq Loglevel::WARN
    end

    it 'has the expected ActiveRecord::Base settings' do
      loglevel # force instantiation
      expect(::ActiveRecord::Base.logger).to eq loglevel.logger
      expect(::ActiveRecord::Base.logger.level).to eq Loglevel::WARN
    end

    it 'has the expected HttpLogger settings' do
      loglevel # force instantiation
      expect(::HttpLogger.level).to eq :warn
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
      let(:loglevel) { Loglevel.setup }

      before { ENV.store Loglevel::ENV_VAR_LEVEL, 'INFO' }
      after { ENV.delete Loglevel::ENV_VAR_LEVEL }

      it 'has the expected logger class' do
        expect(loglevel.send(:logger_class)).to eq ::MyLogger
      end

      it 'has the expected device' do
        expect(loglevel.send(:device)).to eq STDERR
      end

      it 'has the expected log level' do
        loglevel # force instantiation
        expect(Rails.logger).to eq loglevel.logger
        expect(Rails.logger.level).to eq Loglevel::INFO
      end
    end

    context 'HTTP but not ActiveRecord' do
      let(:loglevel) { Loglevel.setup }

      before { ENV.store Loglevel::ENV_VAR_LEVEL, 'INFO,NOBODY,NOHEADERS,NOAR' }
      after { ENV.delete Loglevel::ENV_VAR_LEVEL }

      it 'has the expected ActiveRecord::Base settings' do
        loglevel # force instantiation
        expect(::ActiveRecord::Base.logger).to eq loglevel.send(:null_logger)
      end

      it 'has the expected HttpLogger settings' do
        loglevel # force instantiation
        expect(::HttpLogger.level).to eq :info
        expect(::HttpLogger.log_response_body).to be_falsey
        expect(::HttpLogger.log_headers).to be_falsey
        expect(::HttpLogger.ignore).to include(/9200/, /7474/)
      end
    end

    context 'ActiveRecord but not HTTP' do
      let(:loglevel) { Loglevel.setup }

      before { ENV.store Loglevel::ENV_VAR_LEVEL, 'INFO,NOHTTP' }
      after { ENV.delete Loglevel::ENV_VAR_LEVEL }

      it 'has the expected ActiveRecord::Base settings' do
        loglevel # force instantiation
        expect(::ActiveRecord::Base.logger).to eq loglevel.logger
        expect(::ActiveRecord::Base.logger.level).to eq Loglevel::INFO
      end

      it 'has the expected HttpLogger settings' do
        loglevel # force instantiation
        expect(::HttpLogger.level).to eq :fatal
        expect(::HttpLogger.log_response_body).to be_falsey
        expect(::HttpLogger.log_headers).to be_falsey
        expect(::HttpLogger.ignore).to be_nil
      end
    end
  end
end
