RSpec.describe Loglevel::LoggableClass do
  it 'sets up the class' do
    expect { Loglevel::LoggableClass.new('String').setup }.to raise_error(Loglevel::Exception::ClassNotLoggable)
  end
end
