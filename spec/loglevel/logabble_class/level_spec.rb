RSpec.describe Loglevel::LoggableClass::Level do
  let(:rails) { Loglevel::LoggableClass.new('Rails') }
  let(:http) { Loglevel::LoggableClass.new('HttpLogger') }
  let(:active_record) { Loglevel::LoggableClass.new('ActiveRecord::Base') }

  before(:example) { load 'spec/support/setup_rails_classes.rb' }
  after(:example)  { load 'spec/support/teardown_rails_classes.rb' }

  context 'no environment variable' do
    it 'has the expected level' do
      expect(Loglevel::LoggableClass::Level.new(rails).level_name).to eq('WARN')
      expect(Loglevel::LoggableClass::Level.new(http).level_name).to eq('WARN')
      expect(Loglevel::LoggableClass::Level.new(active_record).level_name).to eq('WARN')
    end
  end

  context 'no HTTP logging' do
    before { ENV.store Loglevel::ENV_VAR_LEVEL, 'noHTTP' } # the capitalization is intentional
    after { ENV.delete Loglevel::ENV_VAR_LEVEL }

    it 'has the expected level' do
      expect(Loglevel::LoggableClass::Level.new(rails).level_name).to eq('WARN')
      expect(Loglevel::LoggableClass::Level.new(http).level_name).to eq('FATAL')
      expect(Loglevel::LoggableClass::Level.new(active_record).level_name).to eq('WARN')
    end
  end

  context 'no ActiveRecord logging' do
    before { ENV.store Loglevel::ENV_VAR_LEVEL, 'noAR' } # the capitalization is intentional
    after { ENV.delete Loglevel::ENV_VAR_LEVEL }

    it 'has the expected level' do
      expect(Loglevel::LoggableClass::Level.new(rails).level_name).to eq('WARN')
      expect(Loglevel::LoggableClass::Level.new(http).level_name).to eq('WARN')
      expect(Loglevel::LoggableClass::Level.new(active_record).level_name).to eq('FATAL')
    end
  end

  context 'no HTTP or ActiveRecord logging' do
    before { ENV.store Loglevel::ENV_VAR_LEVEL, 'noAR,nOhTtP' } # the capitalization is intentional
    after { ENV.delete Loglevel::ENV_VAR_LEVEL }

    it 'has the expected level' do
      expect(Loglevel::LoggableClass::Level.new(rails).level_name).to eq('WARN')
      expect(Loglevel::LoggableClass::Level.new(http).level_name).to eq('FATAL')
      expect(Loglevel::LoggableClass::Level.new(active_record).level_name).to eq('FATAL')
    end
  end
end
