RSpec.shared_examples 'expected_log_settings' do |env, active_record_level, http_level, log_response_body, log_headers|
  before do
    ENV.store Loglevel::ENV_VAR_LEVEL, env
    loglevel.setup
  end

  after { ENV.delete Loglevel::ENV_VAR_LEVEL }

  it 'has the expected ActiveRecord::Base settings' do
    expect(::ActiveRecord::Base.logger.level).to eq active_record_level
  end

  it 'has the expected HttpLogger level' do
    expect(::HttpLogger.level).to eq http_level
  end

  it 'has the expected HttpLogger log_response_body setting' do
    expect(::HttpLogger.log_response_body).to((log_response_body ? be_truthy : be_falsey))
  end

  it 'has the expected HttpLogger log_headers setting' do
    expect(::HttpLogger.log_headers).to((log_headers ? be_truthy : be_falsey))
  end

  it 'has the expected HttpLogger ignore setting' do
    expect(::HttpLogger.ignore).to include(/9200/, /7474/)
  end
end
