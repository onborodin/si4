#!/usr/bin/env ruby

require 'sinatra'

set :public_folder, 'public'
set :views, 'tmpl'

get '/' do
    erb :index
end
#EOF
