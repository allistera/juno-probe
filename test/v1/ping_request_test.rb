require_relative '../test_helper.rb'

describe PingRequest do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  before do
    ENV['JUNO_PROBE_SECRET'] = 'foobar'
  end

  describe 'authentication' do
    it 'returns 401 if no token is provided ' do
      post_json '/v1/ping', { hostname: '' }.to_json, format: :json
      last_response.must_be_unauthorized
    end

    it 'returns 401 if invalid token is provided ' do
      post_json '/v1/ping', { hostname: '' }.to_json, 'HTTP_AUTHORIZATION' => 'Bearer aaa'
      last_response.must_be_unauthorized
    end

    it 'returns 401 if empty token is provided ' do
      post_json '/v1/ping', { hostname: '' }.to_json, 'HTTP_AUTHORIZATION' => 'Bearer '
      last_response.must_be_unauthorized
    end
  end

  describe 'ping request' do
    it 'sends simple request ' do
      object = mock('object')
      object.expects(:ping?).returns(true)
      object.expects(:duration).returns(100)
      Net::Ping::External.expects(:new).with('example.com').returns(object)

      post_json '/v1/ping', { 'hostname' => 'example.com' }, 'HTTP_AUTHORIZATION' => 'Bearer foobar'

      last_response.must_be_ok
      assert_equal true, last_json_response['result']['status']
      assert_equal 100, last_json_response['result']['response_time']
    end

    it 'returns failure' do
      object = mock('object')
      object.expects(:ping?).returns(false)
      object.expects(:duration).returns(nil)
      Net::Ping::External.expects(:new).with('failure.com').returns(object)

      post_json '/v1/ping', { 'hostname' => 'failure.com' }, 'HTTP_AUTHORIZATION' => 'Bearer foobar'

      last_response.must_be_ok
      assert_equal false, last_json_response['result']['status']
      assert_nil last_json_response['result']['response_time']
    end
  end
end
