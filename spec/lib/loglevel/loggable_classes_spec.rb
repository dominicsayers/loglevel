RSpec.describe Loglevel::LoggableClasses do
  context 'setup with no environment variable' do
    let(:loggable_classes) { described_class.clone }

    it('has the expected loggable classes') { expect(loggable_classes.length).to be_zero }
  end

  context 'setup with environment variable' do
    let(:loggable_classes) { described_class.clone }

    before { ENV.store  Loglevel::ENV_VAR_CLASSES, 'String,Array , Hash,NotAClass' } # the spacing is intentional
    after  { ENV.delete Loglevel::ENV_VAR_CLASSES }
    it('has the expected loggable classes') { expect(loggable_classes.classes).to eq([]) }
  end

  context 'with Rails classes defined' do
    let(:loggable_classes) { described_class.clone }

    before { load 'fixtures/setup_rails_classes.rb' }
    after  { load 'fixtures/teardown_rails_classes.rb' }
    it('has the expected loggable classes') { expect(loggable_classes.length).to eq(3) }
  end
end
