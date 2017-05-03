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
        { name: 'ActiveRecord::Base', logger: ActiveSupport::TaggedLogging, level: 'WARN' },
        { name: 'HttpLogger', logger: ActiveSupport::TaggedLogging, level: 'WARN' }
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
      it_behaves_like 'expected_log_settings', 'INFO,NOBODY,NOHEADERS,NOAR', Loglevel::FATAL, :info, false, false
    end

    context 'ActiveRecord but not HTTP' do
      it_behaves_like 'expected_log_settings', 'INFO,NOHTTP', Loglevel::INFO, :fatal, true, true

      it 'has the expected ActiveRecord::Base settings' do
        expect(::ActiveRecord::Base.logger).to be_a ActiveSupport::TaggedLogging
      end
    end
  end
end
