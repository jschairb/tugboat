require 'rubygems'
require 'sinatra'
require 'rest_client'
require 'resque'
require 'yaml'

config = YAML.load_file("settings.yml")

Resque.redis = Redis.new(:host => config["localhost"], :port => config["port"],
  :password => config["password"]
)

module Webhook
  @queue = :webhooks

  def self.perform(webhook)
    RestClient.post webhook['url'], webhook["params"].to_json,
      :content_type => :json, :accept => :json
  end
end

post '/' do
  Resque.enqueue(Webhook, params['webhook'])
  status 200
end
