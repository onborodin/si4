#!/usr/bin/env ruby

require 'sinatra'
require 'pg'

set :public_folder, 'public'
set :views, 'tmpl'

get '/' do
    haml :index
end
#EOF
