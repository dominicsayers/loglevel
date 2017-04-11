RSpec.describe Loglevel::Help do
  before(:context) { load 'spec/support/define_rails_classes.rb' }
  after(:context)  { load 'spec/support/teardown_rails_classes.rb' }

  it 'shows information about itself' do
    expect(Loglevel.inspect).to eq '#<Loglevel: logger=MyDefaultLogger, device=STDOUT, level=WARN, settings=[]>'
  end

  it 'shows debug information about logged classes' do
    expect(Loglevel.debug).to eq <<-DEBUG.gsub('      ', '').chomp
      Rails: logger=MyDefaultLogger, device=#<IO:<STDOUT>>, level=WARN
      ActiveRecord::Base: logger=MyDefaultLogger, device=#<IO:<STDOUT>>, level=WARN
      HttpLogger: logger=MyDefaultLogger, device=#<IO:<STDOUT>>, level=WARN
    DEBUG
  end
end
