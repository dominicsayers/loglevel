require 'logger'

RSpec.describe Loglevel::ActiveRecord do
  before do
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
  end

  after do
    Object.send(:remove_const, :MyClass)
    Object.send(:remove_const, :Rails)
    Object.send(:remove_const, :ActiveRecord)
    Object.send(:remove_const, :HttpLogger)
  end

  context 'NOAR' do
    before do
      ENV.store Loglevel::ENV_VAR_LEVEL, 'noAR' # the capitalization is intentional
      Loglevel.setup
    end

    after { ENV.delete Loglevel::ENV_VAR_LEVEL }

    it 'has the expected ActiveRecord settings' do
      expect(::ActiveRecord::Base.logger).to eq Loglevel.send(:null_logger)
      expect(::ActiveRecord::Base.logger.level).to eq Logger.const_get('FATAL')
    end
  end
end
