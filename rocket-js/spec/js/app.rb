require 'rubygems'
require 'sinatra'
require 'erb'
require 'rocket-js'

Rocket::JS::Builder.new(File.expand_path("../public/testing", __FILE__), false).generate

get '/' do
  erb :index
end

post '/trigger' do
  r = Rocket[params['channel']].trigger(params['event'], params['data'], params['socket_id'])
  p r
end
