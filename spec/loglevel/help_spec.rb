RSpec.describe Loglevel::Help do
  context 'HELP' do
    before do
      class MyLogDevice
        attr_reader :filename, :dev

        def initialize(device)
          @dev = device
        end
      end

      class MyLogger
        INFO = 1
        attr_accessor :level

        def initialize(device)
          @logdev = MyLogDevice.new(device)
        end

        def info(message); end
      end

      ENV.store Loglevel::ENV_VAR_LOGGER, 'MyLogger'
      ENV.store Loglevel::ENV_VAR_DEVICE, 'MyDevice'
      ENV.store Loglevel::ENV_VAR_LEVEL, 'Help' # the capitalization is intentional
    end

    after do
      ENV.delete Loglevel::ENV_VAR_LOGGER
      ENV.delete Loglevel::ENV_VAR_DEVICE
      ENV.delete Loglevel::ENV_VAR_LEVEL
      Object.send(:remove_const, :MyLogger)
      Object.send(:remove_const, :MyLogDevice)
    end

    it 'has the expected ActiveRecord settings' do
      expect_any_instance_of(MyLogger).to receive(:info).once
      Loglevel.setup
    end

    it 'shows information about itself' do
      expect(Loglevel.setup.inspect).to eq(
        '#<Loglevel: logger=MyLogger, device=MyDevice, level=INFO, settings=["HELP"]>'
      )
    end

    it 'shows debugging information about itself' do
      class MyClass
        class << self
          attr_accessor :logger
        end
      end

      class Rails < MyClass; end

      module ActiveRecord
        class Base < Rails; end
      end

      class HttpLogger < Rails
        class << self
          attr_accessor :level, :log_response_body, :log_headers, :ignore
        end
      end

      expect(Loglevel.setup.debug).to eq <<-DEBUG.gsub('        ', '').chomp
        Rails: logger=MyLogger, device=MyDevice, level=INFO
        ActiveRecord::Base: logger=MyLogger, device=MyDevice, level=INFO
        HttpLogger: logger=MyLogger, device=MyDevice, level=INFO
      DEBUG

      Object.send(:remove_const, :MyClass)
      Object.send(:remove_const, :Rails)
      Object.send(:remove_const, :ActiveRecord)
      Object.send(:remove_const, :HttpLogger)
    end
  end
end
