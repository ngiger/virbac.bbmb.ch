#!/usr/bin/env ruby
# Selenium::TestLogin -- bbmb.ch -- 21.09.2006 -- hwyss@ywesee.com

$: << File.expand_path('..', File.dirname(__FILE__))

require "selenium/unit"

module BBMB
  module Selenium
class TestLogin < Test::Unit::TestCase
  include Selenium::TestCase
  def test_login
    open "/"
    assert_equal "BBMB", get_title
    assert is_text_present("Wilkommen bei Virbac")
    assert_equal "E-Mail Adresse", get_text("//label[@for='email']")
    assert is_element_present("email")
    assert_equal "Passwort", get_text("//label[@for='pass']")
    assert is_element_present("pass")
    assert_match Regexp.new(BBMB.config.http_server), 
      get_attribute("//form[@name='login']@action")
    assert is_element_present("//input[@name='login']")
  end
  def test_login__french
    open "/fr"
    assert_equal "BBMB", get_title
    assert is_text_present("Bienvenue chez Virbac")
    assert_equal "Adresse e-mail", get_text("//label[@for='email']")
    assert is_element_present("email")
    assert_equal "Mot de passe", get_text("//label[@for='pass']")
    assert is_element_present("pass")
    assert_match Regexp.new(BBMB.config.http_server), 
      get_attribute("//form[@name='login']@action")
    assert is_element_present("//input[@name='login']")
    ## go back to german
    open "/de"
    assert is_text_present("Wilkommen bei Virbac")
  end
  def test_login__fail_unknown_user
    open "/"
    assert_equal "BBMB", get_title
    @auth.should_receive(:login).and_return { raise Yus::UnknownEntityError }
    type "email", "unknown@bbmb.ch"
    type "pass", "secret"
    click "//input[@type='submit']"
    wait_for_page_to_load "30000"
    assert_equal "BBMB", get_title
    assert_equal "error", get_attribute("//label[@for='email']@class")
  end
  def test_login__fail_wrong_password
    open "/"
    assert_equal "BBMB", get_title
    @auth.should_receive(:login).and_return { raise Yus::AuthenticationError }
    type "email", "unknown@bbmb.ch"
    type "pass", "secret"
    click "//input[@type='submit']"
    wait_for_page_to_load "30000"
    assert_equal "BBMB", get_title
    assert_equal "error", get_attribute("//label[@for='pass']@class")
  end
  def test_login__force_home
    open "/"
    assert_equal "BBMB", get_title
    open "/de/home"
    assert is_text_present("Wilkommen bei V")
    assert is_element_present("email")
    assert is_element_present("pass")
    assert is_element_present("//input[@name='login']")
  end
  def test_logout__clean
    @auth.should_ignore_missing
    @persistence.should_receive(:all).and_return([])
    user = login_admin
    assert is_element_present("link=Abmelden")
    assert_equal "Abmelden", get_text("link=Abmelden")
    click "link=Abmelden"
    wait_for_page_to_load "30000"
    assert_equal "BBMB", get_title
    assert_equal "E-Mail Adresse", get_text("//label[@for='email']")
    assert is_element_present("email")
    assert_equal "Passwort", get_text("//label[@for='pass']")
    assert is_element_present("pass")
    open "/de/customers"
    # session is now invalid, we stay in login-mask
    assert_equal "BBMB", get_title
    assert_equal "E-Mail Adresse", get_text("//label[@for='email']")
    assert is_element_present("email")
    assert_equal "Passwort", get_text("//label[@for='pass']")
    assert is_element_present("pass")
  end
  def test_logout__timeout
    @auth.should_ignore_missing
    @persistence.should_receive(:all).and_return([])
    user = login_admin
    user.should_receive(:expired?).and_return(true)
    user.should_receive(:logout)
    refresh
    wait_for_page_to_load "30000"
    assert_equal "BBMB", get_title
    assert is_element_present("email")
    assert is_element_present("pass")
  end
  def test_logout__disconnect
    @auth.should_ignore_missing
    @persistence.should_receive(:all).and_return([])
    user = login_admin
    user.should_receive(:expired?).and_return { raise DRb::DRbError }
    refresh
    wait_for_page_to_load "30000"
    assert_equal "BBMB", get_title
    assert is_element_present("email")
    assert is_element_present("pass")
  end
  def test_new_customer_form
    open "/"
    assert_equal "BBMB", get_title
    assert is_text_present "Neuer Kunde"
    assert_equal <<-EOS.strip,  get_text("//div[@class='new-customer']")
Bestellen Sie jetzt online. Wir richten für Sie den auf Ihre Praxis
zugeschnittenen, benutzerfreundlichen E-Shop ein! Unsere Mitarbeiter im
Kundendienst beraten Sie gerne!
    EOS
    assert is_element_present "new-customer"
    assert !is_visible("//div[@id='new-customer']")
    click "//div[@class='new-customer']"
    sleep 1
    assert is_visible("//div[@id='new-customer']")

    click "//input[@name='request_access']"
    wait_for_page_to_load "30000"
    assert is_visible("//div[@id='new-customer']")
    assert is_text_present "Bitte füllen Sie alle Felder aus."

    type 'firstname', "First Name"
    type 'lastname', "Last Name"
    type 'organisation', "Organisation"
    type 'address1', "Address 123"
    type 'plz', "4567"
    type 'city', "Somewhere"
    type 'phone_business', "012 345 6789"
    type "//div[@id='new-customer']//input[@name='email']", "test@email.com"
    type 'customer_id', "890123"

    mail = flexstub(BBMB::Util::Mail)
    expected = <<-EOS
Vorname:        First Name
Name:           Last Name
Tierarztpraxis: Organisation
Strasse / Nr.:  Address 123
PLZ:            4567
Ort:            Somewhere
Tel. Praxis:    012 345 6789
E-Mail Adresse: test@email.com
TVS/Virbac-Nr:  890123
    EOS
    mail.should_receive(:send_request).and_return { |sender, org, body|
      assert_equal 'test@email.com', sender
      assert_equal 'Organisation', org
      assert_equal expected, body
    }

    click "//input[@name='request_access']"
    wait_for_page_to_load "30000"
    assert is_text_present <<-EOS
Ihre Anfrage wurde erfolgreich abgeschickt. Sie wird geprüft und innerhalb eines Werktags verarbeitet.
Beste Grüsse. Virbac Schweiz AG
    EOS

    wait_for_page_to_load "30000"
    assert_equal "BBMB", get_title
    assert_equal <<-EOS.strip,  get_text("//div[@class='new-customer']")
Bestellen Sie jetzt online. Wir richten für Sie den auf Ihre Praxis
zugeschnittenen, benutzerfreundlichen E-Shop ein! Unsere Mitarbeiter im
Kundendienst beraten Sie gerne!
    EOS
  end
  def test__delivery_conditions
    open "/"
    assert_equal "BBMB", get_title
    assert is_text_present "Lieferbedingungen"
    assert_equal false, is_visible("//div[@id='delivery-conditions']")
    assert_equal <<-EOS.strip,  get_text("//div[@id='delivery-conditions']")
Mit der Anmeldung nehme ich die Geschäftsbedingungen zur Kenntnis
und erkläre mich damit einverstanden, dass Produkte und
insbesondere Impfstoffe und Biologika bis spätestens Donnerstag,
14:00 Uhr bestellt werden müssen, um tags darauf geliefert werden
zu können.

Bei Fragen oder Problemen kontaktieren Sie uns bitte unter
info@virbac.ch oder 044/809.11.22
    EOS
    click "//div[@class='login-foot']"
    sleep 1
    assert_equal true, is_visible("//div[@id='delivery-conditions']")
    click "//div[@class='login-foot']"
    sleep 1
    sleep 1
    assert_equal false, is_visible("//div[@id='delivery-conditions']")
  end
end
  end
end
