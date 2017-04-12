RSpec.describe Loglevel do
  context 'no environment variable' do
    context 'no Rails environment' do
      let(:loglevel) { Loglevel.clone }

      it 'sets up with the expected defaults' do
        loglevel.setup
        expect(loglevel.debug).to eq([])
      end
    end

    context 'in Rails environment' do
      let(:loglevel) { Loglevel.clone }

      before(:example) { load 'spec/support/setup_rails_classes.rb' }
      after(:example)  { load 'spec/support/teardown_rails_classes.rb' }

      it 'sets up with the expected defaults' do
        loglevel.setup

        expect(loglevel.debug).to include(
          Hash[name: 'Rails', logger: ActiveSupport::TaggedLogging, level: 'WARN'],
          Hash[name: 'ActiveRecord::Base', logger: ActiveSupport::TaggedLogging, level: 'WARN'],
          Hash[name: 'HttpLogger', logger: ActiveSupport::TaggedLogging, level: 'WARN']
        )
      end

      context 'HTTP but not ActiveRecord' do
        before { ENV.store Loglevel::ENV_VAR_LEVEL, 'INFO,NOBODY,NOHEADERS,NOAR' }
        after { ENV.delete Loglevel::ENV_VAR_LEVEL }

        it 'has the expected ActiveRecord::Base settings' do
          loglevel.setup
          expect(::ActiveRecord::Base.logger.level).to eq Loglevel::FATAL
        end

        it 'has the expected HttpLogger settings' do
          loglevel.setup
          expect(::HttpLogger.level).to eq :info
          expect(::HttpLogger.log_response_body).to be_falsey
          expect(::HttpLogger.log_headers).to be_falsey
          expect(::HttpLogger.ignore).to include(/9200/, /7474/)
        end
      end

      context 'ActiveRecord but not HTTP' do
        before { ENV.store Loglevel::ENV_VAR_LEVEL, 'INFO,NOHTTP' }
        after { ENV.delete Loglevel::ENV_VAR_LEVEL }

        it 'has the expected ActiveRecord::Base settings' do
          loglevel.setup
          expect(::ActiveRecord::Base.logger).to be_a ActiveSupport::TaggedLogging
          expect(::ActiveRecord::Base.logger.level).to eq Loglevel::INFO
        end

        it 'has the expected HttpLogger settings' do
          loglevel.setup
          expect(::HttpLogger.level).to eq :fatal
          expect(::HttpLogger.log_response_body).to be_truthy
          expect(::HttpLogger.log_headers).to be_truthy
          expect(::HttpLogger.ignore).to include(/9200/, /7474/)
        end
      end
    end
  end
end
