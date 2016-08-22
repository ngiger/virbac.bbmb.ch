#!/usr/bin/env ruby
# encoding: utf-8
require 'spec_helper'

describe "virbac.bbmb" do

  before :all do
    @idx = 0
    waitForVirbacToBeReady(@browser, VirbacUrl)
  end
  
  before :each do
    @browser.goto VirbacUrl
  end

  after :each do
    @idx += 1
    createScreenshot(@browser, '_'+@idx.to_s)
    logout
  end

  after :all do
    @browser.close
  end

  describe "admin" do
    before :all do
    end
    before :each do
      @browser.goto VirbacUrl
      logout if /Abmelden/.match(@browser.text)
      login(AdminUser, AdminPassword)
    end
    after :all do
      logout if /Abmelden/.match(@browser.text)
    end
    it "admin should be able to login" do
      @browser.goto "#{VirbacUrl}/de/customer/customer_id/4100609297"
      windowSize = @browser.windows.size
      expect(@browser.url).to match VirbacUrl
      text = @browser.text.clone
      expect(@browser.url).to match VirbacUrl
      expect(@browser.link(:name, 'logout').exist?).to eq true
      expect(text).to match /Abmelden/
    end
  end

end
