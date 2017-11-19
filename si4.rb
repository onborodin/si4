#!@RUBY@

require 'json'
require 'sinatra/base'
require 'logger'
require 'pg'

require 'digest/md5' 
require 'digest/sha1' 
require 'base64' 
require 'htauth'

require 'thin'

class SecureThinBackend < Thin::Backends::TcpServer
  def initialize(host, port, options)
    super(host, port)
    @ssl = true
    @ssl_options = options
  end
end

class App < Sinatra::Base

    @@pwfile = "@APP_CONFDIR@/pw"

    @weblog = "@APP_LOGDIR@/access.log"
    @errlog = "@APP_LOGDIR@/error.log"
    @pidfile = "@APP_RUNDIR@/pid"

    @crtfile = "@APP_CONFDIR@/crt"
    @keyfile = "@APP_CONFDIR@/key"

    def self.pidfile
        @pidfile
    end

    def self.errlog
        @errlog
    end

    def user?(user, password)
        logger.info("Auth: User #{user} try access")
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
        logfile = File.new(@weblog, 'a')
        logfile.sync = true
        use Rack::CommonLogger, logfile

        set :public_folder, '@APP_LIBDIR@/public'
        set :views, '@APP_LIBDIR@/templ'
        set :server, "thin"
        set :secret, '3d04dd2b1403a7ed52373953e8bbf921'
        set :port, 8081
        set :bind, '0.0.0.0'

        set :sessions, true
        set :show_exceptions, true 
        set :logging, true
        set :dump_errors, true
        set :raise_errors, true
        set :quiet, true

        class << settings
            def server_settings
                {
                    :backend          => SecureThinBackend,
                    :private_key_file => @keyfile,
                    :cert_chain_file  => @crtfile,
                    :verify_peer      => false
                }
            end
        end
    end

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

    before do
        logger.datetime_format = '%Y-%m-%d %H:%M:%S'
        logger.formatter = proc do |severity, datetime, progname, msg|
            "#{datetime}: #{severity} #{msg}\n"
        end
        user = session[:user] || 'undef'
        logger.info("#{request.request_method} #{request.url} from #{request.ip} as #{session[:user]}")
    end
end

Process.euid = Etc.getpwnam("root").uid
Process.daemon

errlog = File.new(App.errlog, "a+")
errlog.sync = true
$stdout.reopen(errlog)
$stderr.reopen(errlog)

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
