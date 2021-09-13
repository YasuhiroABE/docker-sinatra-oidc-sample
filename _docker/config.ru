require 'bundler/setup'
Bundler.require
require './lib/myoidcprovider'
require './lib/myconfig'

use Rack::Session::Redis, {
  :redis_server => MyConfig::REDIS_URI,
  :namespace    => "rack:session",
  :expire_after => 600
}

require './my_app'
run MyApp
