RSpec.shared_examples 'expected_log_levels' do |env_var, rails_level, http_level, active_record_level|
  before { ENV.store(Loglevel::ENV_VAR_LEVEL, env_var) if env_var }
  after { ENV.delete(Loglevel::ENV_VAR_LEVEL) }

  it 'has the expected Rails log level' do
    expect(described_class.new(rails).level_name).to eq(rails_level)
  end

  if http_level
    it 'has the expected HTTP log level' do
      expect(described_class.new(http).level_name).to eq(http_level)
    end
  else
    it 'does not set HTTP log level' do
      expect { described_class.new(http) }.to raise_error(Loglevel::Exception::ClassNotLoggable)
    end
  end

  it 'has the expected ActiveRecord log level' do
    expect(described_class.new(active_record).level_name).to eq(active_record_level)
  end
end
