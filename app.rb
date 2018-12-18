require 'sinatra'
require 'require_all'

require_all 'lib'

set :port, 8080
set :bind, '0.0.0.0'

RegisterProbe.run unless ENV.key? 'JUNO_PROBE_DISABLE_REGISTRATION'

before do
  content_type :json
end

get '/v1/healthcheck' do
  'OK'
end

post '/v1/request' do
  halt 401 unless AuthenticateRequest.authenticated?(env.fetch('HTTP_AUTHORIZATION', ''))
  HttpRequest.run(request)
end

post '/v1/ping' do
  halt 401 unless AuthenticateRequest.authenticated?(env.fetch('HTTP_AUTHORIZATION', ''))
  PingRequest.run(request)
end
