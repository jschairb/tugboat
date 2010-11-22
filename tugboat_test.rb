require 'app'
require 'test/unit'
require 'rack/test'
require 'mocha'

ENV['RACK_ENV'] = 'test'

class TugboatTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_returns_ok_status_code
    Resque.stubs(:enqueue).returns(true)
    post '/'
    assert last_response.ok?
  end

  def test_enqueues_resque_job
    params = { :url => "example.com"}
    Resque.expects(:enqueue).with(Webhook, params).returns(true)
    post '/', :webhook => params
  end
end
