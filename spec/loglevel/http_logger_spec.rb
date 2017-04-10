RSpec.describe Loglevel::HttpLogger do
  before(:context) { load 'spec/support/define_rails_classes.rb' }
  after(:context)  { load 'spec/support/teardown_rails_classes.rb' }

  context 'NOHTTP' do
    let(:loglevel) { Loglevel.setup }

    before { ENV.store Loglevel::ENV_VAR_LEVEL, 'NoHttp' } # the capitalization is intentional
    after { ENV.delete Loglevel::ENV_VAR_LEVEL }

    it 'has the expected HttpLogger settings' do
      loglevel # force instantiation
      expect(::HttpLogger.logger).to eq loglevel.send(:null_logger)
      expect(::HttpLogger.level).to eq :fatal
    end
  end
end
