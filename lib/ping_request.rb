require 'net/ping'

class PingRequest
  def self.run(request)
    payload = JSON.parse(request.body.read)
    ping(payload['hostname']).to_json
  end

  def self.ping(hostname)
    request = Net::Ping::External.new(hostname)
    response(request.ping?, request.duration)
  end

  def self.response(status, duration)
    {
      result: {
        status: status,
        response_time: duration
      }
    }
  end
end
