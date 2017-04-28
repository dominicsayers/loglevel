RSpec.describe Loglevel do
  context 'no Rails environment' do
    let(:loglevel) { described_class.clone }

    it 'sets up with the expected defaults' do
      loglevel.setup
      expect(loglevel.debug).to eq([])
    end
  end

  context 'in Rails environment' do
    let(:loglevel) { described_class.clone }

    let(:debug) do
      [
        { name: 'Rails', logger: ActiveSupport::TaggedLogging, level: 'WARN' },
        { name: 'ActiveRecord::Base', logger: ActiveSupport::TaggedLogging, level: 'WARN' },
        { name: 'HttpLogger', logger: ActiveSupport::TaggedLogging, level: 'WARN' }
      ]
    end

    before { load 'spec/support/setup_rails_classes.rb' }
    after  { load 'spec/support/teardown_rails_classes.rb' }

    shared_examples 'expected_log_settings' do |active_record_level, http_level, log_response_body, log_headers|
      it 'has the expected ActiveRecord::Base settings' do
        expect(::ActiveRecord::Base.logger.level).to eq active_record_level
      end

      it 'has the expected HttpLogger level' do
        expect(::HttpLogger.level).to eq http_level
      end

      it 'has the expected HttpLogger log_response_body setting' do
        expect(::HttpLogger.log_response_body).to((log_response_body ? be_truthy : be_falsey))
      end

      it 'has the expected HttpLogger log_headers setting' do
        expect(::HttpLogger.log_headers).to((log_headers ? be_truthy : be_falsey))
      end

      it 'has the expected HttpLogger ignore setting' do
        expect(::HttpLogger.ignore).to include(/9200/, /7474/)
      end
    end

    it 'sets up with the expected defaults' do
      loglevel.setup
      expect(loglevel.debug).to include(*debug)
    end

    context 'HTTP but not ActiveRecord' do
      before do
        ENV.store Loglevel::ENV_VAR_LEVEL, 'INFO,NOBODY,NOHEADERS,NOAR'
        loglevel.setup
      end

      after { ENV.delete Loglevel::ENV_VAR_LEVEL }

      it_behaves_like 'expected_log_settings', Loglevel::FATAL, :info, false, false
    end

    context 'ActiveRecord but not HTTP' do
      before do
        ENV.store Loglevel::ENV_VAR_LEVEL, 'INFO,NOHTTP'
        loglevel.setup
      end

      after { ENV.delete Loglevel::ENV_VAR_LEVEL }

      it_behaves_like 'expected_log_settings', Loglevel::INFO, :fatal, true, true

      it 'has the expected ActiveRecord::Base settings' do
        expect(::ActiveRecord::Base.logger).to be_a ActiveSupport::TaggedLogging
      end
    end
  end
end
