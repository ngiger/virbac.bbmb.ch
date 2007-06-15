#!/usr/bin/env ruby
# Selenium::TestResult -- bbmb.ch -- 22.09.2006 -- hwyss@ywesee.com

$: << File.expand_path('..', File.dirname(__FILE__))

require 'selenium/unit'

module BBMB
  module Selenium
class TestResult < Test::Unit::TestCase
  include Selenium::TestCase
  def test_result__empty
    user = login_customer
    flexstub(Model::Product).should_receive(:search_by_description).times(1).and_return { 
      |query|
      assert_equal 'product', query
      []
    }
    type "query", "product"
    click "document.search.search"
    wait_for_page_to_load "30000"
    assert_equal "BBMB | Suchen", get_title
    assert is_text_present("Suchresultat: 0 Produkte gefunden")
    assert is_element_present("//input[@type='text' and @name='query']")
    assert !is_element_present("//input[@type='submit' and @name='order_product']")
  end
  def test_result__1
    user = login_customer
    product = Model::Product.new('12345')
    product.description = 'product - a description'
    product.price = Util::Money.new(12.50)
    flexstub(Model::Product).should_receive(:search_by_description).times(1).and_return { 
      |query|
      assert_equal 'product', query
      [product]
    }
    type "query", "product"
    click "document.search.search"
    wait_for_page_to_load "30000"
    assert_equal "BBMB | Suchen", get_title
    assert is_text_present("Suchresultat: 1 Produkt gefunden")
    assert is_element_present("//input[@type='text' and @name='query']")
    assert is_element_present("//input[@type='submit' and @name='order_product']")
    assert is_element_present("//input[@name='quantity[12345]']")
    assert_equal '0', get_value("//input[@name='quantity[12345]']")
    assert !is_text_present("im Rückstand")
  end
  def test_result__order
    BBMB.persistence.should_ignore_missing
    user = login_customer
    product = Model::Product.new('12345')
    product.description = 'product - a description'
    product.price = Util::Money.new(11.50)
    flexstub(Model::Product).should_receive(:search_by_description).times(1).and_return { 
      |query|
      assert_equal 'product', query
      [product]
    }
    type "query", "product"
    click "document.search.search"
    wait_for_page_to_load "30000"
    assert_equal "BBMB | Suchen", get_title
    assert is_element_present("//input[@name='quantity[12345]']")
    assert_equal '0', get_value("//input[@name='quantity[12345]']")
    type "quantity[12345]", "15"
    click "document.products.order_product"
    wait_for_page_to_load "30000"
    assert_equal "BBMB | Warenkorb (Home)", get_title
    assert is_element_present("link=product - a description")
    assert is_text_present("11.50")
    assert is_text_present("172.50")
  end
  def test_result__backorder
    user = login_customer
    product = Model::Product.new('12345')
    product.description = 'product - a description'
    product.price = Util::Money.new(12.50)
    product.backorder = true
    flexstub(Model::Product).should_receive(:search_by_description).times(1).and_return { 
      |query|
      assert_equal 'product', query
      [product]
    }
    type "query", "product"
    click "document.search.search"
    wait_for_page_to_load "30000"
    assert_equal "BBMB | Suchen", get_title
    assert is_text_present("Suchresultat: 1 Produkt gefunden")
    assert is_text_present("im Rückstand")
  end
  def test_result__backorder__date
    user = login_customer
    product = Model::Product.new('12345')
    product.description = 'product - a description'
    product.price = Util::Money.new(12.50)
    product.backorder = true
    date = Date.today >> 1
    product.backorder_date = date
    flexstub(Model::Product).should_receive(:search_by_description).times(1).and_return { 
      |query|
      assert_equal 'product', query
      [product]
    }
    type "query", "product"
    click "document.search.search"
    wait_for_page_to_load "30000"
    assert_equal "BBMB | Suchen", get_title
    assert is_text_present("Suchresultat: 1 Produkt gefunden")
    expected = date.strftime("im Rückstand bis %d.%m.%Y")
    assert is_text_present(expected)
  end
  def test_result__sort
    user = login_customer
    product1 = Model::Product.new('12345')
    product1.description = 'product 1'
    product1.price = Util::Money.new(12.50)
    product2 = Model::Product.new('12345')
    product2.description = 'product 2'
    product2.price = Util::Money.new(10.50)
    flexstub(Model::Product).should_receive(:search_by_description).times(1).and_return { 
      |query|
      assert_equal 'product', query
      [product1, product2]
    }
    type "query", "product"
    click "document.search.search"
    wait_for_page_to_load "30000"
    assert_equal "BBMB | Suchen", get_title
    assert is_text_present("Suchresultat: 2 Produkte gefunden")
    assert_equal 'product 1', get_text("//tr[2]/td[3]")
    assert_equal 'product 2', get_text("//tr[4]/td[3]")

    click "link=Preis"
    wait_for_page_to_load "30000"
    assert is_text_present("Suchresultat: 2 Produkte gefunden")
    assert_equal 'product 2', get_text("//tr[2]/td[3]")
    assert_equal 'product 1', get_text("//tr[4]/td[3]")

    click "link=Preis"
    wait_for_page_to_load "30000"
    assert is_text_present("Suchresultat: 2 Produkte gefunden")
    assert_equal 'product 1', get_text("//tr[2]/td[3]")
    assert_equal 'product 2', get_text("//tr[4]/td[3]")
  end
  def test_result__has_ordered_products
    BBMB.persistence.should_ignore_missing
    user = login_customer
    product = Model::Product.new('12345')
    product.description = 'product - a description'
    product.price = Util::Money.new(11.50)
    @customer.current_order.add(5, product)
    flexstub(Model::Product).should_receive(:search_by_description).times(1).and_return { 
      |query|
      assert_equal 'product', query
      [product]
    }
    type "query", "product"
    click "document.search.search"
    wait_for_page_to_load "30000"
    assert_equal "BBMB | Suchen", get_title
    assert is_element_present("//input[@name='quantity[12345]']")
    assert_equal '5', get_value("//input[@name='quantity[12345]']")
    type "quantity[12345]", "trigger an error!"
    click "document.products.order_product"
    wait_for_page_to_load "30000"
    assert_equal "BBMB | Suchen", get_title
    assert is_element_present("//input[@name='quantity[12345]']")
    assert_equal '5', get_value("//input[@name='quantity[12345]']")
    type "quantity[12345]", "10"
    click "document.products.order_product"
    wait_for_page_to_load "30000"
    assert_equal "BBMB | Warenkorb (Home)", get_title
    assert_equal(10, @customer.current_order.quantity(product))
  end
  def test_result__promotion
    BBMB.persistence.should_ignore_missing
    user = login_customer
    today = Date.today
    promo = Model::Promotion.new
    promo.start_date = today - 2
    promo.end_date = today
    product = Model::Product.new('12345')
    product.description = 'product - a description'
    product.price = Util::Money.new(11.50)
    product.promotion = promo
    flexstub(Model::Product).should_receive(:search_by_description).times(1).and_return { 
      |query|
      assert_equal 'product', query
      [product]
    }
    type "query", "product"
    click "document.search.search"
    wait_for_page_to_load "30000"
    assert_equal "BBMB | Suchen", get_title
    assert is_element_present('promotion-12345')
    assert_match(%r{/de/promotions}, 
                 get_attribute('promotion-12345@href'))

    promo.end_date = today - 1
    refresh
    wait_for_page_to_load "30000"
    assert !is_element_present('promotion-12345')

    promo.start_date = today + 1
    promo.end_date = today + 2
    refresh
    wait_for_page_to_load "30000"
    assert !is_element_present('promotion-12345')

    promo.start_date = today
    refresh
    wait_for_page_to_load "30000"
    assert is_element_present('promotion-12345')

    BBMB.persistence.should_receive(:all).with(Model::Product)\
      .and_return { [product] }
    click 'link=P'
    wait_for_page_to_load "30000"
    assert_equal "BBMB | Promotionen", get_title
  end
  def test_result__sale
    BBMB.persistence.should_ignore_missing
    user = login_customer
    today = Date.today
    promo = Model::Promotion.new
    promo.start_date = today - 2
    promo.end_date = today
    product = Model::Product.new('12345')
    product.description = 'product - a description'
    product.price = Util::Money.new(11.50)
    product.sale = promo
    flexstub(Model::Product).should_receive(:search_by_description).times(1).and_return { 
      |query|
      assert_equal 'product', query
      [product]
    }
    type "query", "product"
    click "document.search.search"
    wait_for_page_to_load "30000"
    assert_equal "BBMB | Suchen", get_title
    assert is_element_present('sale-12345')
    assert_match(%r{/de/promotions}, 
                 get_attribute('sale-12345@href'))

    promo.end_date = today - 1
    refresh
    wait_for_page_to_load "30000"
    assert !is_element_present('sale-12345')

    promo.start_date = today + 1
    promo.end_date = today + 2
    refresh
    wait_for_page_to_load "30000"
    assert !is_element_present('sale-12345')

    promo.start_date = today
    refresh
    wait_for_page_to_load "30000"
    assert is_element_present('sale-12345')

    BBMB.persistence.should_receive(:all).with(Model::Product)\
      .and_return { [product] }
    click 'link=A'
    wait_for_page_to_load "30000"
    assert_equal "BBMB | Promotionen", get_title
  end
end
  end
end
