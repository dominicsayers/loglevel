RSpec.describe Loglevel::LoggableClass do
  it 'sets up the class' do
    expect { described_class.new('String').setup }.to raise_error(Loglevel::Exception::ClassNotLoggable)
  end
end
