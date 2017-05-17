require 'yus/session'
require 'bbmb/config'
require 'bbmb/virbac'
require 'bbmb/html/util/session'
require 'sbsm/session'
require 'sbsm/app'
require 'ydim/invoice'
require 'bbmb/util/app'
require 'bbmb/util/csv_importer'

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
      super
    end
  end
end
