RSpec.describe Loglevel do
  context 'no Rails environment' do
    before { load 'fixtures/setup_logger_class.rb' }
    after  { load 'fixtures/teardown_logger_class.rb' }

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
        { name: 'ActiveRecord::Base', logger: ActiveSupport::TaggedLogging, level: 'WARN' }
      ]
    end

    before { load 'fixtures/setup_rails_classes.rb' }
    after  { load 'fixtures/teardown_rails_classes.rb' }

    require 'shared_examples/expected_log_settings'

    it 'sets up with the expected defaults' do
      loglevel.setup
      expect(loglevel.debug).to include(*debug)
    end

    context 'HTTP but not ActiveRecord' do
      params = {
        env: 'INFO,HTTP,NOBODY,NOAR',
        active_record_level: Loglevel::FATAL,
        http_level: :info,
        log_response_body: false,
        log_headers: true,
        ignore: [/9200/, /7474/]
      }

      it_behaves_like 'expected_log_settings', params
    end

    context 'ActiveRecord but not HTTP' do
      params = {
        env: 'DEBUG,NOHTTP',
        active_record_level: Loglevel::DEBUG,
        http_level: :warn,
        log_response_body: nil,
        log_headers: nil,
        ignore: []
      }

      it_behaves_like 'expected_log_settings', params

      it 'has the expected ActiveRecord::Base settings' do
        expect(::ActiveRecord::Base.logger).to be_a ActiveSupport::TaggedLogging
      end
    end
  end
end
