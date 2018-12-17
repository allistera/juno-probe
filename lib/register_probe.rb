require 'httparty'

class RegisterProbe
  def self.run
    HTTParty.post(ENV['JUNO_URL'] + '/probes',
                  body: { name: ENV['JUNO_PROBE_NAME'], url: ENV['JUNO_PROBE_URL'] }.to_json,
                  headers: { 'Authorization' => 'Bearer ' + ENV['JUNO_PROBE_SECRET'],
                             'Content-Type' => 'application/json' })
  end
end
