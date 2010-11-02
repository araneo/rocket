LOAD_PATH.unshift(File.expand_path('../../lib', __FILE__))

require 'rubygems'
require 'sinatra'
require 'erb'
require 'rocket'

set :public, public_path = File.expand_path('../../dist/', __FILE__)
Rocket::JS::Builder.new(public_path).generate

get '/' do
  erb :index
end

post '/trigger' do
  r = Rocket[params['channel']].trigger(params['event'], params['data'], params['socket_id'])
  p r
end
