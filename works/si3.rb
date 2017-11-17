#!/usr/bin/env ruby

require 'sinatra'
require 'pg'

set :public_folder, 'public'
set :views, 'tmpl'
enable :sessions

class Model
  def hello
    "Hello!"
  end
end

m = Model.new

get '/' do
    logger.info "loading data"
    erb :index, :m => m
end
#EOF
