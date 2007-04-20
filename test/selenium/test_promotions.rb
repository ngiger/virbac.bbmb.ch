#!/usr/bin/env ruby
# Selenium::TestPromotions -- bbmb -- 20.04.2007 -- hwyss@ywesee.com

$: << File.expand_path('..', File.dirname(__FILE__))
$: << File.expand_path('../lib', File.dirname(__FILE__))

require 'selenium/unit'

module BBMB
  module Selenium
class TestPromotions < Test::Unit::TestCase
  include Selenium::TestCase
  def test_promotions
    user = login_customer
    assert_equal "BBMB | Home", @selenium.get_title

    today = Date.today
    promo1 = Model::Promotion.new
    promo1.lines = ['promo1 20 x 1 Packung']
    promo1.start_date = today - 1
    promo1.end_date = today + 1

    prod1 = Model::Product.new(12345)
    prod1.description = 'Product1'
    prod1.price = Util::Money.new(10.0)
    prod1.promotion = promo1

    promo2 = Model::Promotion.new
    promo2.lines = ['promo2 20 x 1 Packung']
    promo2.start_date = today - 2
    promo2.end_date = today - 1
    sale1 = Model::Promotion.new
    sale1.lines = ['sale1 15 x 1 Packung']
    sale1.start_date = today - 1
    sale1.end_date = today + 1

    prod2 = Model::Product.new(12346)
    prod2.description = 'Product2'
    prod2.price = Util::Money.new(20.0)
    prod2.promotion = promo2
    prod2.sale = sale1

    sale2 = Model::Promotion.new
    sale2.lines = ['sale2 15 x 1 Packung']
    sale2.start_date = today - 2
    sale2.end_date = today - 1
    prod3 = Model::Product.new(12346)
    prod3.description = 'Product3'
    prod3.price = Util::Money.new(30.0)

    #Model::Product.instances.push(prod1, prod2, prod3)
    @persistence.should_receive(:all).with(Model::Product)\
      .and_return(Model::Product.instances)

    click 'link=Promotionen'
    wait_for_page_to_load "30000"
    assert_equal "BBMB | Promotionen", @selenium.get_title

    assert is_element_present('link=promo1 20 x 1 Packung')
    assert !is_element_present('link=promo2 20 x 1 Packung')
    assert is_element_present('link=sale1 15 x 1 Packung')
    assert !is_element_present('link=sale2 15 x 1 Packung')
    assert_equal 'Product1', get_text('//tr[2]/td[1]')
    assert_equal 'Product2', get_text('//tr[3]/td[1]')


    flexstub(Model::Product).should_receive(:find_by_article_number)\
      .and_return(prod2)
    @persistence.should_receive(:save)
    click 'link=sale1 15 x 1 Packung'
    wait_for_page_to_load "30000"
    assert_equal "BBMB | Home", @selenium.get_title
    assert is_text_present('Product2')
    assert is_text_present('15')
    assert is_text_present('Aktuelle Bestellung: 1 Positionen')

    mouse_over 'link=A'
    assert !60.times { 
      break if (is_text_present("sale1 15 x 1 Packung") rescue false)
      sleep 1 
    }
  end
end
  end
end
