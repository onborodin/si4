#!@RUBY@

require 'json'
require 'sinatra/base'
require 'logger'
require 'pg'

require 'digest/md5' 
require 'digest/sha1' 
require 'base64' 
require 'htauth'

class ErrorLogger
  def initialize(file)
    @file = File.new(file, "a+")
    @file.sync = true
  end
  def puts(msg)
    @file.puts("--- ERROR --- #{Time.now.strftime("%d %b %Y %H:%M:%S %z")}: ")
    @file.puts(msg)
  end
end

class App < Sinatra::Base

    @@pwfile = "@APP_CONFDIR@/si4.pw"

    @logfile = "@APP_LOGDIR@/access.log"
    @errfile = "@APP_LOGDIR@/error.log"
    @pidfile = "@APP_RUNDIR@/app.pid"

#    errlogger = ErrorLogger.new(@errfile)

    class << self
        attr_accessor :logfile
        attr_accessor :errfile
        attr_accessor :pidfile
        attr_accessor :pwfile
    end

    def user?(user, password)
        return false unless File.readable?(@@pwfile)
        File.open(@@pwfile).each do | line |
            htuser, digest = line.strip.split(':')
            next unless htuser == user
            if digest.match(/apr1/) then
                dummy, apr, salt = digest.split('$')
                md5 = HTAuth::Md5.new( 'salt' => salt )
                if md5.encode(password) == digest then
                    return true
                end
            elsif digest.match(/SHA/) then
                sha1 = HTAuth::Sha1.new
                if sha1.encode(password) == digest then
                    return true
                end
            end
        end
        return false
    end

    configure do
        logfile = File.new(@logfile, 'a+')
        logfile.sync = true
        use Rack::CommonLogger, logfile


        set :public_folder, '@APP_LIBDIR@/public'
        set :views, '@APP_LIBDIR@/templ'
        set :server, "thin"
        set :secret, '3d04dd2b1403a7ed52373953e8bbf921'
        set :port, 8081
        set :bind, '0.0.0.0'

        enable :sessions
        enable :show_exceptions 
        disable :logging
        enable :dump_errors
        enable :raise_errors
    end


#    before do
#      env["rack.errors"] =  errlogger
#    end

    not_found do
        erb :not_found
    end

    error do
        erb :error
    end

    error 401 do
        redirect to '/login'
    end

    helpers do
        def auth? 
            halt 401 unless session[:user]
        end
    end

    get '/login' do
        erb :login, :layout => false
    end

    post '/login' do
        if user?(params['username'], params['password']) then
                session[:user] = params['username']
                redirect to "/"
        else
            erb :login, :layout => false
        end
    end

    get '/logout' do
        session.clear
        redirect to '/login'
    end

    get '/hello' do 
        content_type :json
        { message: "hello" }.to_json
    end

    get '/' do
        auth?
        erb :index
    end
end

#Process.euid = Etc.getpwnam("www").uid
Process.daemon

logr = File.new(App.errfile, "a+")
logr.sync = true
$stdout.reopen(logr)
$stderr.reopen(logr)

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
