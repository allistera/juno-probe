require_relative '../test_helper.rb'

describe RegisterProbe do
  include Rack::Test::Methods

  it 'registers on bootup' do
    ENV['JUNO_URL'] = 'https://foobar.com'
    ENV['JUNO_PROBE_NAME'] = 'EU/WEST'
    ENV['JUNO_PROBE_URL'] = 'https://aaa.com'
    ENV['JUNO_PROBE_SECRET'] = 'AVC'

    HTTParty.expects(:post).with('https://foobar.com/probes',
                                 body: '{"name":"EU/WEST","url":"https://aaa.com"}',
                                 headers: { 'Authorization' => 'Bearer AVC', 'Content-Type' => 'application/json' })
            .returns(true)
    RegisterProbe.run
  end
end
