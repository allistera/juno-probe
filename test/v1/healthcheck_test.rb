require_relative '../test_helper.rb'

describe '/healthcheck' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it 'returns OK' do
    get '/v1/healthcheck'
    last_response.should.be.ok
    last_response.body.should.equal 'OK'
  end
end
