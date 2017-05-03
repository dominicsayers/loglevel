RSpec.shared_examples 'expected_log_settings' do |params|
  before do
    ENV.store Loglevel::ENV_VAR_LEVEL, params[:env]
    loglevel.setup
  end

  after { ENV.delete Loglevel::ENV_VAR_LEVEL }

  it 'has the expected ActiveRecord::Base settings' do
    expect(::ActiveRecord::Base.logger.level).to eq params[:active_record_level]
  end

  it 'has the expected HttpLogger level' do
    expect(::HttpLogger.level).to eq params[:http_level]
  end

  it 'has the expected HttpLogger log_response_body setting' do
    expect(::HttpLogger.log_response_body).to eq(params[:log_response_body])
  end

  it 'has the expected HttpLogger log_headers setting' do
    expect(::HttpLogger.log_headers).to eq(params[:log_headers])
  end

  if params[:ignore].empty?
    it('ignores nothing') { expect(::HttpLogger.ignore).to be_nil }
  else
    it('ignores Redis and ElasticSearch') { expect(::HttpLogger.ignore).to include(*params[:ignore]) }
  end
end
