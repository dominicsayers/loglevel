RSpec.describe Loglevel::LoggableClass::SmartLogger do
  let(:smart_logger) { described_class.clone }

  context 'no environment variable' do
    it 'handles no available logger class' do
      expect { smart_logger.create }.to raise_error(
        Loglevel::Exception::UnknownLoggerClass,
        'Logger'
      )
    end
  end

  context 'logger class set by environment variable' do
    context 'logger class not available' do
      before { ENV.store  Loglevel::ENV_VAR_LOGGER, 'Log4r' }
      after  { ENV.delete Loglevel::ENV_VAR_LOGGER }

      it 'handles no available logger class' do
        expect { smart_logger.create }.to raise_error(
          Loglevel::Exception::UnknownLoggerClass,
          'Log4r'
        )
      end
    end

    context 'logger class is available' do
      before do
        ENV.store  Loglevel::ENV_VAR_LOGGER, 'String'
        ENV.store  Loglevel::ENV_VAR_DEVICE, 'tmp/test.log'
      end

      after do
        ENV.delete Loglevel::ENV_VAR_LOGGER
        ENV.delete Loglevel::ENV_VAR_DEVICE
      end

      it 'returns an instance of the logger class' do
        expect(smart_logger.create).to eq('tmp/test.log')
      end
    end
  end
end
