RSpec.describe Loglevel::ActiveRecord do
  before(:context) { load 'spec/support/define_rails_classes.rb' }
  after(:context)  { load 'spec/support/teardown_rails_classes.rb' }

  context 'NOAR' do
    let(:loglevel) { Loglevel.setup }

    before { ENV.store Loglevel::ENV_VAR_LEVEL, 'noAR' } # the capitalization is intentional
    after { ENV.delete Loglevel::ENV_VAR_LEVEL }

    it 'has the expected ActiveRecord settings' do
      loglevel # force instantiation
      expect(::ActiveRecord::Base.logger).to eq loglevel.send(:null_logger)
      expect(::ActiveRecord::Base.logger.level).to eq MyDefaultLogger.const_get('FATAL')
    end
  end
end
