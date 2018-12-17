require_relative '../test_helper.rb'

describe HttpRequest do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  before do
    ENV['JUNO_PROBE_SECRET'] = 'foobar'
  end

  describe 'authentication' do
    it 'returns 401 if no token is provided ' do
      post_json '/v1/request', { url: '', verify_ssl: true }.to_json, format: :json
      last_response.must_be_unauthorized
    end

    it 'returns 401 if invalid token is provided ' do
      post_json '/v1/request', { url: '', verify_ssl: true }.to_json, 'HTTP_AUTHORIZATION' => 'Bearer aaa'
      last_response.must_be_unauthorized
    end

    it 'returns 401 if empty token is provided ' do
      post_json '/v1/request', { url: '', verify_ssl: true }.to_json, 'HTTP_AUTHORIZATION' => 'Bearer '
      last_response.must_be_unauthorized
    end
  end

  describe 'http request' do
    it 'sends simple HTTP request ' do
      HTTParty.expects(:get).with('https://example.com', verify: nil, basic_auth: nil).returns(stub(code: 200))
      Time.expects(:now).twice.returns(100, 200)

      post_json '/v1/request', { 'url' => 'https://example.com' }, 'HTTP_AUTHORIZATION' => 'Bearer foobar'

      last_response.must_be_ok
      assert_equal 200, last_json_response['Result']['StatusCode']
      assert_equal 100, last_json_response['Result']['ResponseTime']
    end

    it 'sends HTTP request unverified' do
      HTTParty.expects(:get).with('https://example.com', verify: false, basic_auth: nil).returns(stub(code: 200))
      Time.expects(:now).twice.returns(100, 200)

      post_json '/v1/request',
                { 'url' => 'https://example.com', 'verify_ssl' => false },
                'HTTP_AUTHORIZATION' => 'Bearer foobar'

      last_response.must_be_ok
      assert_equal 200, last_json_response['Result']['StatusCode']
      assert_equal 100, last_json_response['Result']['ResponseTime']
    end

    it 'sends HTTP request with basic auth' do
      HTTParty
        .expects(:get)
        .with('https://example.com', verify: nil, basic_auth: { 'username' => 'foo', 'password' => 'bar' })
        .returns(stub(code: 200))
      Time.expects(:now).twice.returns(100, 200)

      post_json '/v1/request',
                { 'url' => 'https://example.com', 'basic_auth': { 'username' => 'foo', 'password' => 'bar' } },
                'HTTP_AUTHORIZATION' => 'Bearer foobar'

      last_response.must_be_ok
      assert_equal 200, last_json_response['Result']['StatusCode']
      assert_equal 100, last_json_response['Result']['ResponseTime']
    end

    it 'returns nil on SocketError' do
      HTTParty.expects(:get).raises(SocketError)

      post_json '/v1/request', { 'url' => 'https://dsaer23qre3wew3.com' }, 'HTTP_AUTHORIZATION' => 'Bearer foobar'

      last_response.must_be_ok
      assert_nil last_json_response['Result']['StatusCode']
      assert_nil last_json_response['Result']['ResponseTime']
    end
  end
end
