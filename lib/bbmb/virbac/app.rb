require 'yus/session'
require 'bbmb/config'
require 'bbmb/virbac'
require 'bbmb/html/util/session'
require 'sbsm/session'
require 'sbsm/app'
require 'ydim/invoice'
require 'bbmb/util/server'

module VIRBAC
  VERSION = `git rev-parse HEAD`
  require 'bbmb/config'
  [ File.join(Dir.pwd, 'etc', 'config.yml'),
  ].each do |config_file|
    if File.exist?(config_file)
      puts "BBMB.config.load from #{config_file}"
      BBMB.config.load (config_file)
      break
    end
  end

  class App < BBMB::Util::App
    attr_accessor :db_manager, :yus_server
    attr_accessor :auth, :config, :persistence, :server

    def self.get_server
      case BBMB.config.persistence
      when 'odba'
        DRb.install_id_conv ODBA::DRbIdConv.new
        @persistence = BBMB::Persistence::ODBA
      end
      @auth = DRb::DRbObject.new(nil, BBMB.config.auth_url)
      @server = BBMB::Util::Server.new(@persistence, self)
      @server.extend(DRbUndumped)
      @server
    end

    def start_service
      case BBMB.config.persistence
      when 'odba'
        DRb.install_id_conv ODBA::DRbIdConv.new
        @persistence = BBMB::Persistence::ODBA
      end
      @auth = DRb::DRbObject.new(nil, BBMB.config.auth_url)
      puts "installed @auth #{@auth}"
      @server = App.get_server
      if(BBMB.config.update?)
        @server.run_updater
      end
      if(BBMB.config.invoice?)
        @server.run_invoicer
      end
      url = BBMB.config.server_url
      url.untaint
      DRb.start_service(url, @server)
      $SAFE = 1
      $0 = BBMB.config.name
      SBSM.logger.info('start') { sprintf("starting bbmb-server on %s", url) }
      DRb.thread.join
      SBSM.logger.info('finished') { sprintf("starting bbmb-server on %s", url) }
    rescue Exception => error
      SBSM.logger.error('fatal') { error }
      raise
    end
    def login(email, pass)
      session = BBMB.auth.login(email, pass, BBMB.config.auth_domain)
      Html::Util::KnownUser.new(session)
    end

    def logout(session)
      BBMB.auth.logout(session)
    rescue DRb::DRbError, RangeError, NameError
    end

    def initialize
      SBSM.logger= ChronoLogger.new(BBMB.config.log_pattern)
      SBSM.logger.level = :debug
      puts "Starting Rack-Service #{self.class} and service #{BBMB.config.server_url}"
      super
      Thread.new {
          start_service
      }
    end
  end
end
