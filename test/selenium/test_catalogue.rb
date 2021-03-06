#!/usr/bin/env ruby
# Selenium::TestCatalogue -- bbmb -- 20.04.2007 -- hwyss@ywesee.com

$: << File.expand_path('..', File.dirname(__FILE__))
$: << File.expand_path('../lib', File.dirname(__FILE__))

require 'selenium/unit'

module BBMB
  module Selenium
class TestCatalogue < Test::Unit::TestCase
  include Selenium::TestCase
  def test_catalogue
    user = login_customer
    assert_equal "BBMB | Warenkorb (Home)", @selenium.get_title

    prod1 = Model::Product.new(12345)
    prod1.catalogue1.de = 'Kleintiere'
    prod1.catalogue1.fr = 'Petits Animaux'
    prod1.catalogue2.de = 'Zahnhygiene'
    prod1.catalogue2.fr = 'Hygiène buccodentaire'
    prod1.description.de = 'Product1'
    prod1.description.fr = 'FrenchProduct1'
    prod1.price = Util::Money.new(10.0)

    prod2 = Model::Product.new(12346)
    prod2.catalogue1.de = 'Großtiere'
    prod2.catalogue2.de = 'Antiphlogistika'
    prod2.description.de = 'Product2'
    prod2.price = Util::Money.new(20.0)

    prod3 = Model::Product.new(12346)
    prod3.catalogue1.fr = 'Großtiere'
    prod3.catalogue2.fr = 'Gastroenterologika'
    prod3.description.fr = 'Product3'
    prod3.price = Util::Money.new(30.0)

    #Model::Product.instances.push(prod1, prod2, prod3)
    @persistence.should_receive(:all).with(Model::Product)\
      .and_return(Model::Product.instances)

    click '//a[@name="catalogue"]'
    wait_for_page_to_load "30000"
    assert_equal "BBMB | Katalog", @selenium.get_title
    assert is_element_present('link=Großtiere')
    assert is_element_present('link=Kleintiere')
    assert !is_element_present('link=Antiphlogistika')
    assert !is_element_present('link=Gastroenterologika')
    assert !is_element_present('link=Zahnhygiene')
    assert !is_element_present('link=Product1')
    assert !is_element_present('link=Product2')
    assert !is_element_present('link=Product3')

    click 'link=Großtiere'
    wait_for_page_to_load "30000"
    assert_equal "BBMB | Katalog", @selenium.get_title
    assert is_element_present('link=Großtiere')
    assert is_element_present('link=Kleintiere')
    assert is_element_present('link=Antiphlogistika')
    assert is_element_present('link=Gastroenterologika')
    assert !is_element_present('link=Zahnhygiene')
    assert !is_element_present('link=Product1')
    assert !is_element_present('link=Product2')
    assert !is_element_present('link=Product3')

    click 'link=Kleintiere'
    wait_for_page_to_load "30000"
    assert_equal "BBMB | Katalog", @selenium.get_title
    assert is_element_present('link=Großtiere')
    assert is_element_present('link=Kleintiere')
    assert !is_element_present('link=Antiphlogistika')
    assert !is_element_present('link=Gastroenterologika')
    assert is_element_present('link=Zahnhygiene')
    assert !is_element_present('link=Product1')
    assert !is_element_present('link=Product2')
    assert !is_element_present('link=Product3')

    click 'link=Zahnhygiene'
    wait_for_page_to_load "30000"
    assert_equal "BBMB | Katalog", @selenium.get_title
    assert is_element_present('link=Großtiere')
    assert is_element_present('link=Kleintiere')
    assert !is_element_present('link=Antiphlogistika')
    assert !is_element_present('link=Gastroenterologika')
    assert is_element_present('link=Zahnhygiene')
    assert is_element_present('link=Product1')
    assert !is_element_present('link=Product2')
    assert !is_element_present('link=Product3')

    flexstub(Model::Product).should_receive(:find_by_article_number)\
      .and_return(prod1)
    @persistence.should_receive(:save)
    click 'link=Product1'
    wait_for_page_to_load "30000"
    assert_equal "BBMB | Warenkorb (Home)", @selenium.get_title
    assert is_text_present('Product1')
    assert is_text_present('Aktuelle Bestellung: 1 Positionen')
  end
  def test_catalogue__survives_nil_values
    user = login_customer
    assert_equal "BBMB | Warenkorb (Home)", @selenium.get_title

    prod1 = Model::Product.new(12345)
    prod1.catalogue1.de = 'Kleintiere'
    prod1.catalogue1.fr = 'Petits Animaux'
    prod1.catalogue2.de = 'Zahnhygiene'
    prod1.catalogue2.fr = 'Hygiène buccodentaire'
    prod1.description.de = 'Product1'
    prod1.description.fr = 'FrenchProduct1'
    prod1.price = Util::Money.new(10.0)

    prod2 = Model::Product.new(12346)
    prod2.catalogue1.de = 'Großtiere'
    prod2.catalogue2.de = 'Antiphlogistika'
    prod2.description.de = 'Product2'
    prod2.price = Util::Money.new(20.0)

    prod3 = Model::Product.new(12346)
    prod3.catalogue1.fr = 'Großtiere'
    prod3.catalogue2.fr = 'Gastroenterologika'
    prod3.description.fr = 'Product3'
    prod3.price = Util::Money.new(30.0)

    prod4 = Model::Product.new(12346)
    prod4.catalogue1.fr = nil
    prod4.catalogue2.fr = 'Gastroenterologika'
    prod4.description.fr = 'Product3'
    prod4.price = Util::Money.new(30.0)

    prod5 = Model::Product.new(12346)
    prod5.catalogue1.fr = 'Großtiere'
    prod5.catalogue2.fr = nil
    prod5.description.fr = 'Product3'
    prod5.price = Util::Money.new(30.0)

    prod6 = Model::Product.new(12346)
    prod6.catalogue1.fr = 'Großtiere'
    prod6.catalogue2.fr = 'Gastroenterologika'
    prod6.description.fr = nil
    prod6.price = Util::Money.new(30.0)

    #Model::Product.instances.push(prod1, prod2, prod3)
    @persistence.should_receive(:all).with(Model::Product)\
      .and_return(Model::Product.instances)

    click '//a[@name="catalogue"]'
    wait_for_page_to_load "30000"
    assert_equal "BBMB | Katalog", @selenium.get_title
    assert is_element_present('link=Großtiere')
    assert is_element_present('link=Kleintiere')
    assert !is_element_present('link=Antiphlogistika')
    assert !is_element_present('link=Gastroenterologika')
    assert !is_element_present('link=Zahnhygiene')
    assert !is_element_present('link=Product1')
    assert !is_element_present('link=Product2')
    assert !is_element_present('link=Product3')

    click 'link=Großtiere'
    wait_for_page_to_load "30000"
    assert_equal "BBMB | Katalog", @selenium.get_title
    assert is_element_present('link=Großtiere')
    assert is_element_present('link=Kleintiere')
    assert is_element_present('link=Antiphlogistika')
    assert is_element_present('link=Gastroenterologika')
    assert !is_element_present('link=Zahnhygiene')
    assert !is_element_present('link=Product1')
    assert !is_element_present('link=Product2')
    assert !is_element_present('link=Product3')

    click 'link=Kleintiere'
    wait_for_page_to_load "30000"
    assert_equal "BBMB | Katalog", @selenium.get_title
    assert is_element_present('link=Großtiere')
    assert is_element_present('link=Kleintiere')
    assert !is_element_present('link=Antiphlogistika')
    assert !is_element_present('link=Gastroenterologika')
    assert is_element_present('link=Zahnhygiene')
    assert !is_element_present('link=Product1')
    assert !is_element_present('link=Product2')
    assert !is_element_present('link=Product3')

    click 'link=Zahnhygiene'
    wait_for_page_to_load "30000"
    assert_equal "BBMB | Katalog", @selenium.get_title
    assert is_element_present('link=Großtiere')
    assert is_element_present('link=Kleintiere')
    assert !is_element_present('link=Antiphlogistika')
    assert !is_element_present('link=Gastroenterologika')
    assert is_element_present('link=Zahnhygiene')
    assert is_element_present('link=Product1')
    assert !is_element_present('link=Product2')
    assert !is_element_present('link=Product3')

    flexstub(Model::Product).should_receive(:find_by_article_number)\
      .and_return(prod1)
    @persistence.should_receive(:save)
    click 'link=Product1'
    wait_for_page_to_load "30000"
    assert_equal "BBMB | Warenkorb (Home)", @selenium.get_title
    assert is_text_present('Product1')
    assert is_text_present('Aktuelle Bestellung: 1 Positionen')
  end
end
  end
end
