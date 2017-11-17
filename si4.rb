#!/usr/bin/env ruby

require 'json'
require 'sinatra/base'
require 'logger'
require 'pg'

class App < Sinatra::Base

    @logfile = "@APP_LOGDIR@/access.log"
    @errfile = "@APP_LOGDIR@/error.log"
    @pidfile = "@APP_RUNDIR@/app.pid"

    class << self
        attr_accessor :logfile
        attr_accessor :errfile
        attr_accessor :pidfile
    end

    configure do
        logfile = File.new(@logfile, 'a+')
        logfile.sync = true
        use Rack::CommonLogger, logfile
    end

    set :public_folder, '@APP_LIBDIR@/public'
    set :views, '@APP_LIBDIR@/tmpl'
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
        content_type :json
        { message: "hello" }.to_json
    end
end

#Process.euid = Etc.getpwnam("www").uid
Process.daemon true, true

begin
    File.open(App.pidfile, 'w') do
            |file| file.write Process.pid
    end
rescue
    puts "Cannot write pid file #{App.pidfile}\n"
    exit
end

App.run!

File.delete App.pidfile if File.exist? App.pidfile

#EOF
