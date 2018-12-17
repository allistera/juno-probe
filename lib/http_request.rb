require 'httparty'

class HttpRequest
  def self.run(request)
    payload = JSON.parse(request.body.read)
    http(payload['url'], payload['verify_ssl'], payload['basic_auth']).to_json
  end

  def self.http(url, verify_ssl, basic_auth = {})
    start = Time.now
    request = HTTParty.get(url, verify: verify_ssl, basic_auth: basic_auth)
    response_time = Time.now - start
    response(request.code, response_time)
  rescue SocketError
    response(nil, nil)
  end

  def self.response(code, time)
    {
      Result: {
        StatusCode: code,
        ResponseTime: time
      }
    }
  end
end
