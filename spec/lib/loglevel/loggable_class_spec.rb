RSpec.describe Loglevel::LoggableClass do
  before { load 'fixtures/setup_logger_class.rb' }
  after  { load 'fixtures/teardown_logger_class.rb' }

  it 'sets up the class' do
    expect { described_class.new('String').setup }.to raise_error(Loglevel::Exception::ClassNotLoggable)
  end
end
