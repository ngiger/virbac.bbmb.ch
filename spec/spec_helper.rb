#!/usr/bin/env ruby
# encoding: utf-8
# require 'simplecov'
# SimpleCov.start


RSpec.configure do |config|
  config.mock_with :flexmock
  config.expect_with :rspec do |c|
    c.syntax = [:should, :expect]
  end
end

BreakIntoPry = false
begin
  require 'pry'
rescue LoadError
  # ignore error for Travis-CI
end
$LOAD_PATH << File.join(File.dirname(File.dirname(__FILE__)), 'lib')

require 'fileutils'
require 'pp'

AdminPassword     = ENV['VIRBAC_ADMIN_PASSWD']
AdminUser         = 'admin@virbac.ch'
VirbacUrl           = 'http://virbac.bbmb.ngiger.ch/'

Flavor    = 'sbsm'
ImageDest = File.join(Dir.pwd, 'images')
Browser2test = [ :chrome ]
require 'watir'
DownloadDir = File.expand_path(File.join(File.dirname(__FILE__), '..', 'downloads'))
GlobAllDownloads  = File.join(DownloadDir, '*')
LeeresResult      =  /hat ein leeres Resultat/

def setup_browser
  return if @browser
  FileUtils.makedirs(DownloadDir)
  if Browser2test[0].to_s.eql?('firefox')
    puts "Setting upd default profile for firefox"
    profile = Selenium::WebDriver::Firefox::Profile.new
    profile['browser.download.dir'] = DownloadDir
    profile['browser.download.folderList'] = 2
    profile['browser.helperApps.alwaysAsk.force'] = false
    profile['browser.helperApps.neverAsk.saveToDisk'] = "application/zip;application/octet-stream;application/x-zip;application/x-zip-compressed;text/csv;test/semicolon-separated-values"

    @browser = Watir::Browser.new :firefox, :profile => profile
  elsif Browser2test[0].to_s.eql?('chrome')
    puts "Setting up a default profile for chrome"
    prefs = {
      :download => {
        :prompt_for_download => false,
        :default_directory => DownloadDir
      }
    }
    @browser = Watir::Browser.new :chrome, :prefs => prefs
  elsif Browser2test[0].to_s.eql?('ie')
    puts "Trying unknown browser type Internet Explorer"
    @browser = Watir::Browser.new :ie
  else
    puts "Trying unknown browser type #{Browser2test[0]}"
    @browser = Watir::Browser.new Browser2test[0]
  end
end

def login(user = ViewerUser, password=ViewerPassword, remember_me=false)
  setup_browser
  @browser.goto VirbacUrl
  sleep 0.5
  @browser.text_field(:name, 'email').wait_until(&:present?).set(user)
  @browser.text_field(:name, 'pass').wait_until(&:present?).set(password)
  @browser.button(:name,"login").click
  sleep 1 unless @browser.link(:name,"logout").exists?
  if  p
    @browser.goto(VirbacUrl)
    return false
  else
    return true
  end
end

def get_session_timestamp
  @@timestamp ||= Time.now.strftime('%Y%m%d_%H%M%S')
end

def logout
  setup_browser
  @browser.goto VirbacUrl
  sleep(0.1) unless @browser.link(:name=>'logout').exists?
  logout_btn = @browser.link(:name=>'logout')
  return unless  logout_btn.exists?
  logout_btn.click
end

def waitForVirbacToBeReady(browser = nil, url = VirbacUrl, maxWait = 30)
  setup_browser
  startTime = Time.now
  @seconds = -1
  0.upto(maxWait).each{
    |idx|
   @browser.goto VirbacUrl; small_delay
    unless /Es tut uns leid/.match(@browser.text)
      @seconds = idx
      break
    end
    if idx == 0
      $stdout.write "Waiting max #{maxWait} seconds for #{url} to be ready"; $stdout.flush
    else
      $stdout.write('.'); $stdout.flush
    end
    sleep 1
  }
  endTime = Time.now
  sleep(0.2)
  @browser.link(:text=>'Plus').click if @browser.link(:text=>'Plus').exists?
  puts "Took #{(endTime - startTime).round} seconds for for #{VirbacUrl} to be ready. First answer was after #{@seconds} seconds." if (endTime - startTime).round > 2
end

def small_delay
  sleep(0.1)
end

def createScreenshot(browser, added=nil)
  small_delay
  if browser.url.index('?')
    name = File.join(ImageDest, File.basename(browser.url.split('?')[0]).gsub(/\W/, '_'))
  else
    name = File.join(ImageDest, browser.url.split('/')[-1].gsub(/\W/, '_'))
  end
  FileUtils.makedirs(ImageDest) unless File.exist?(ImageDest)
  name = "#{name}#{added}.png"
  browser.screenshot.save (name)
  puts "createScreenshot: #{name} done" if $VERBOSE
end

def show_threads
  Thread.list.each do |thread|
    STDERR.puts "Thread-#{thread.object_id.to_s(36)}"
    STDERR.puts thread.backtrace.join("\n    \\_ ")
  end
end
