#!/usr/bin/env ruby

require 'sinatra/base'
require 'logger'
require 'pg'

class App < Sinatra::Base

    errfile = File.new("error.log", 'a+')
    errfile.sync = true

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

    before do
        env["rack.errors"] = 
    end

    get '/' do
        logger.info "loading data"
        erb :index
    end

end

App.run!
#EOF
