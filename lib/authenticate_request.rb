class AuthenticateRequest
  def self.authenticated?(header)
    ENV['JUNO_PROBE_SECRET'] == header.slice(7..-1)
  end
end
