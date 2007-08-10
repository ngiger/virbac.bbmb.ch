#!/usr/bin/env ruby
# Selenium::TestQuotas -- de.oddb.org -- 20.04.2007 -- hwyss@ywesee.com

$: << File.expand_path('..', File.dirname(__FILE__))
$: << File.expand_path('../lib', File.dirname(__FILE__))

require 'selenium/unit'
require 'bbmb/model/quota'

module BBMB
  module Selenium
class TestPromotions < Test::Unit::TestCase
  include Selenium::TestCase
  def test_quotas
    user = login_customer
    assert_equal "BBMB | Warenkorb (Home)", @selenium.get_title

    prod1 = Model::Product.new(12345)
    prod1.description.de = 'Product1'
    prod1.description.fr = 'FrenchProduct1'
    prod1.price = Util::Money.new(10.0)
    quota = Model::Quota.new(prod1)
    quota.start_date = Date.new(2007)
    quota.end_date = Date.new(2007,12,31)
    quota.target = 1000
    quota.actual = 200
    quota.difference = 800
    quota.price = 8.0
    @customer.quotas.push(quota)

    click 'link=Abschlüsse'
    wait_for_page_to_load "30000"
    assert_equal "BBMB | Abschlüsse", get_title

    assert is_text_present('Abschlusspreis')
    assert_equal 'Product1', get_text('//tr[2]/td[1]')
  end
end
  end
end
