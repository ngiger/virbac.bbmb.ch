require 'spec_helper'
require 'flexmock'

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

  describe "as admin user" do
    require 'bbmb/config'
    before :each do
      @browser.goto VirbacUrl
      logout if /Abmelden/.match(@browser.text)
      login(AdminUser, AdminPassword)
    end
    after :all do
      logout if /Abmelden/.match(@browser.text)
    end
  end

  def validate_german_home
    expect(@browser.title).to eq 'BBMB'
    expect(@browser.text).to match('Willkommen bei Virbac')
    expect(@browser.label(:text, 'E-Mail Adresse').exist?).to eq true
    expect(@browser.input(:name, 'pass').exist?).to eq true
    expect(@browser.input(:name, 'email').exist?).to eq true
  end

  describe "login" do
    it "test login" do
      validate_german_home
      expect(@browser.input(:name, 'pass').exist?).to eq true
      login_form = @browser.form(:name, 'login')
      expect(login_form.exist?).to eq true
      # expect(login_form.action).match(Regexp.new(BBMB.config.http_server)) # this is not true for
    end
    it "test login french" do
      expect(@browser.title).to eq 'BBMB'
      expect(@browser.link(:text, 'Français').exist?).to eq true
      @browser.link(:text, 'Français').click
      expect(@browser.text).to match('Bienvenue chez Virbac')
      expect(@browser.label(:text, 'Adresse e-mail').exist?).to eq true
      expect(@browser.label(:text, 'Mot de passe').exist?).to eq true
      expect(@browser.input(:name, 'pass').exist?).to eq true
      expect(@browser.input(:name, 'email').exist?).to eq true
      # expect(login_form.action).match(Regexp.new(BBMB.config.http_server)) # this is not true for
      @browser.goto("#{VirbacUrl}/de")
      expect(@browser.text).to match('Willkommen bei Virbac')
    end
    it "fail unknown user" do
      # @auth.should_receive(:login).and_return { raise Yus::UnknownEntityError }
      @browser.text_field(:name, 'email').when_present.set('unknown@bbmb.ch')
      @browser.text_field(:name, 'pass').when_present.set('secret')
      @browser.form(:name, 'login').submit
      expect(@browser.title).to eq 'BBMB'
      expect(@browser.label(:text, 'E-Mail Adresse').attribute_value('class')).to eq 'error'
    end
    it "fail wrong password" do
      @browser.text_field(:name, 'email').when_present.set(AdminUser)
      @browser.text_field(:name, 'pass').when_present.set('secret')
      @browser.form(:name, 'login').submit
      expect(@browser.title).to eq 'BBMB'
      expect(@browser.label(:text, 'Passwort').attribute_value('class')).to eq 'error'
    end
    it "force home" do
      validate_german_home
      @browser.goto("#{VirbacUrl}/de")
      validate_german_home
    end
    it "force logout clean" do
      expect(@browser.button(:name,"login").exists?).to eq true
      expect(@browser.link(:name,"logout").exists?).to eq false
      login(AdminUser, AdminPassword)
      expect(@browser.button(:name,"login").exists?).to eq false
      expect(@browser.link(:name,"logout").exists?).to eq true
      logout
      expect(@browser.button(:name,"login").exists?).to eq true
      expect(@browser.link(:name,"logout").exists?).to eq false
      @browser.goto("#{VirbacUrl}/de/customers")
      validate_german_home
    end
  end
end
if false
class TestLogin < Test::Unit::TestCase
  include Selenium::TestCase
  binding.pry
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
Mit der Anmeldung nehme ich die Geschäftsbedingungen zur Kenntnis.

Bestellungen, die bei uns bis 14.00 Uhr eingehen, treffen
grundsätzlich am nächsten Arbeitstag beim Kunden ein.

Impfstoff-Bestellungen am späten Donnerstagnachmittag oder am Freitag
werden wie folgt ausgeliefert: Am darauffolgenden Montag (wenn keine Dringlichkeit vermerkt ist) 
 Auf Wunsch am Freitag per Mondexpress, dieser wird am Samstagmorgen bis 
9 Uhr ausgeliefert (Kosten gehen zu Lasten des Kunden)
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