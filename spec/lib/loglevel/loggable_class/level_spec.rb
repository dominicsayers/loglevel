RSpec.describe Loglevel::LoggableClass::Level do
  let(:rails) { Loglevel::LoggableClass.new('Rails') }
  let(:http) { Loglevel::LoggableClass.new('HttpLogger') }
  let(:active_record) { Loglevel::LoggableClass.new('ActiveRecord::Base') }

  before { load 'spec/support/setup_rails_classes.rb' }
  after  { load 'spec/support/teardown_rails_classes.rb' }

  shared_examples 'expected_log_levels' do |rails_level, http_level, active_record_level|
    it 'has the expected Rails log level' do
      expect(described_class.new(rails).level_name).to eq(rails_level)
    end

    it 'has the expected HTTP log level' do
      expect(described_class.new(http).level_name).to eq(http_level)
    end

    it 'has the expected ActiveRecord log level' do
      expect(described_class.new(active_record).level_name).to eq(active_record_level)
    end
  end

  context 'no environment variable' do
    it_behaves_like 'expected_log_levels', 'WARN', 'WARN', 'WARN'
  end

  context 'no HTTP logging' do
    before { ENV.store Loglevel::ENV_VAR_LEVEL, 'noHTTP' } # the capitalization is intentional
    after { ENV.delete Loglevel::ENV_VAR_LEVEL }

    it_behaves_like 'expected_log_levels', 'WARN', 'FATAL', 'WARN'
  end

  context 'no ActiveRecord logging' do
    before { ENV.store Loglevel::ENV_VAR_LEVEL, 'noAR' } # the capitalization is intentional
    after { ENV.delete Loglevel::ENV_VAR_LEVEL }

    it_behaves_like 'expected_log_levels', 'WARN', 'WARN', 'FATAL'
  end

  context 'no HTTP or ActiveRecord logging' do
    before { ENV.store Loglevel::ENV_VAR_LEVEL, 'noAR,nOhTtP' } # the capitalization is intentional
    after { ENV.delete Loglevel::ENV_VAR_LEVEL }

    it_behaves_like 'expected_log_levels', 'WARN', 'FATAL', 'FATAL'
  end
end
