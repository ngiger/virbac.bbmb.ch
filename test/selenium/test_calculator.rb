#!/usr/bin/env ruby
# Selenium::TestCalculator -- bbmb -- 19.04.2007 -- hwyss@ywesee.com

$: << File.expand_path('..', File.dirname(__FILE__))
$: << File.expand_path('../lib', File.dirname(__FILE__))

require 'selenium/unit'

module BBMB
  module Selenium
class TestCalculator < Test::Unit::TestCase
  include Selenium::TestCase
  def test_calculator
    user = login_customer
    assert_equal "BBMB | Warenkorb (Home)", @selenium.get_title

    prod1 = BBMB::Model::Product.new(12345)
    prod1.catalogue1.de = 'Kleintiere'
    prod1.description.de = 'Product1'
    prod1.description.fr = 'FrenchProduct1'
    prod1.price = BBMB::Util::Money.new(10.00)
    prod1.vat = BBMB::Util::Money.new(10.00)

    prod2 = BBMB::Model::Product.new(12346)
    prod2.catalogue1.de = 'Großtiere'
    prod2.description.de = 'Product2'
    prod2.description.fr = 'FrenchProduct2'
    prod2.price = BBMB::Util::Money.new(20.00)
    prod2.vat = BBMB::Util::Money.new(5.00)

    products = [prod1, prod2]
    @persistence.should_receive(:all).with(BBMB::Model::Product)\
      .and_return(products)

    click 'link=Kalkulieren'
    wait_for_page_to_load "30000"

    assert is_element_present('link=Großtiere')
    assert is_element_present('link=Kleintiere')

    assert_equal "BBMB | Kalkulieren", @selenium.get_title
    assert_equal 'Product2', get_text('//tr[2]/td[1]')
    assert_equal '20.00', get_text('//tr[2]/td[2]')
    assert_equal '30.00', get_text('//tr[2]/td[3]')
    assert !is_element_present('//tr[2]/td[4]')

    click 'show_vat'
    assert !60.times { 
      break if (is_element_present("//tr[2]/td[4]") rescue false)
      sleep 1 
    }

    assert_equal '30.00', get_text('//tr[2]/td[3]')
    assert_equal '5.0%', get_text('//tr[2]/td[4]')
    assert_equal '1.50', get_text('//tr[2]/td[5]')
    assert_equal '31.50', get_text('//tr[2]/td[6]')

    type 'factor', '2.0'
    assert !60.times { 
      break if ((get_text("//tr[2]/td[3]") == '40.00') rescue false)
      sleep 1 
    }
    assert_equal '40.00', get_text('//tr[2]/td[3]')
    assert_equal '5.0%', get_text('//tr[2]/td[4]')
    assert_equal '2.00', get_text('//tr[2]/td[5]')
    assert_equal '42.00', get_text('//tr[2]/td[6]')

    click 'show_vat'
    assert !60.times { 
      break if (!is_element_present("//tr[2]/td[4]") rescue false)
      sleep 1 
    }
    assert_equal '40.00', get_text('//tr[2]/td[3]')

    click 'link=Kleintiere'
    wait_for_page_to_load "30000"

    assert_equal "BBMB | Kalkulieren", @selenium.get_title
    assert_equal 'Product1', get_text('//tr[2]/td[1]')
    assert_equal '10.00', get_text('//tr[2]/td[2]')
    assert_equal '20.00', get_text('//tr[2]/td[3]')
    assert !is_element_present('//tr[2]/td[4]')

    type 'factor', '1.1'
    assert !60.times { 
      break if ((get_text("//tr[2]/td[3]") == '11.00') rescue false)
      sleep 1 
    }

    click 'show_vat'
    assert !60.times { 
      break if (is_element_present("//tr[2]/td[4]") rescue false)
      sleep 1 
    }
    assert_equal '11.00', get_text('//tr[2]/td[3]')
    assert_equal '10.0%', get_text('//tr[2]/td[4]')
    assert_equal '1.10', get_text('//tr[2]/td[5]')
    assert_equal '12.10', get_text('//tr[2]/td[6]')
  end
end
  end
end
