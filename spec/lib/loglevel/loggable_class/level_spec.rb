RSpec.describe Loglevel::LoggableClass::Level do
  let(:rails) { Loglevel::LoggableClass.new('Rails') }
  let(:http) { Loglevel::LoggableClass.new('HttpLogger') }
  let(:active_record) { Loglevel::LoggableClass.new('ActiveRecord::Base') }

  before { load 'fixtures/setup_rails_classes.rb' }
  after  { load 'fixtures/teardown_rails_classes.rb' }

  require 'shared_examples/expected_log_levels'

  context 'no environment variable' do
    it_behaves_like 'expected_log_levels', nil, 'WARN', nil, 'WARN'
  end

  context 'with environment variable' do
    context 'no HTTP logging' do
      it_behaves_like 'expected_log_levels', 'noHTTP', 'WARN', nil, 'WARN'
    end

    context 'no ActiveRecord logging' do
      it_behaves_like 'expected_log_levels', 'Http,noAR', 'WARN', 'WARN', 'FATAL'
    end

    context 'no HTTP or ActiveRecord logging' do
      it_behaves_like 'expected_log_levels', 'noAR,nOhTtP', 'WARN', nil, 'FATAL'
    end
  end
end
