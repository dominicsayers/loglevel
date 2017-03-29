RSpec.describe Loglevel::Help do
  context 'HELP' do
    before do
      class MyLogger
        INFO = 1
        attr_accessor :level

        def initialize(device); end

        def info(message); end
      end

      ENV.store Loglevel::ENV_VAR_LOGGER, 'MyLogger'
      ENV.store Loglevel::ENV_VAR_LEVEL, 'Help' # the capitalization is intentional
    end

    after do
      ENV.delete Loglevel::ENV_VAR_LOGGER
      ENV.delete Loglevel::ENV_VAR_LEVEL
    end

    it 'has the expected ActiveRecord settings' do
      expect_any_instance_of(MyLogger).to receive(:info).once
      Loglevel.setup
    end
  end
end
