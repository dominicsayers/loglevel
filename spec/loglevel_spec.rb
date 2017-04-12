RSpec.describe Loglevel do
  context 'no environment variable' do
    context 'no Rails environment' do
      let(:loglevel) { Loglevel.clone }

      it 'sets up with the expected defaults' do
        loglevel.setup
        expect(loglevel.debug).to eq([])
      end
    end

    context 'in Rails environment' do
      let(:loglevel) { Loglevel.clone }

      before(:example) { load 'spec/support/setup_rails_classes.rb' }
      after(:example)  { load 'spec/support/teardown_rails_classes.rb' }

      it 'sets up with the expected defaults' do
        loglevel.setup

        expect(loglevel.debug).to include(
          Hash[name: 'Rails', logger: ActiveSupport::TaggedLogging, level: 'WARN'],
          Hash[name: 'ActiveRecord::Base', logger: ActiveSupport::TaggedLogging, level: 'WARN'],
          Hash[name: 'HttpLogger', logger: ActiveSupport::TaggedLogging, level: 'WARN']
        )
      end
    end
  end
end
