#!/usr/bin/env ruby

require 'json'
require 'sinatra/base'
require 'logger'
require 'pg'

class App < Sinatra::Base

#    errfile = File.new("error.log", 'a+')
#    errfile.sync = true

    configure do
        logfile = File.new("access.log", 'a+')
        logfile.sync = true
        use Rack::CommonLogger, logfile
    end

    set :public_folder, 'public'
    set :views, 'tmpl'
    set :logging, false
    enable :sessions
    set :server, "thin"

    get '/' do
        erb :index
    end

    not_found do
        erb :not_found
    end

    error do
        erb :error
    end

    get '/hello' do 
        { message: "hello" }.to_json
    end
end

Process.daemon(true,true)

pid_file = "si4.pid"
File.open(pid_file, 'w') { |f| f.write Process.pid }

App.run!
#EOF
