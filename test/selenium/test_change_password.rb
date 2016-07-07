#!/usr/bin/env ruby
# Selenium::TestChangePassword -- virbac.bbmb.ch -- 28.06.2007 -- hwyss@ywesee.com

$: << File.expand_path('..', File.dirname(__FILE__))
$: << File.expand_path('../lib', File.dirname(__FILE__))

require 'selenium/unit'

module BBMB
  module Selenium
class TestChangePassword < Test::Unit::TestCase
  include Selenium::TestCase
  def test__getting_there
    user = login_customer
    assert_equal "BBMB | Warenkorb (Home)", @selenium.get_title

    click 'link=Passwort ändern'
    wait_for_page_to_load "30000"

    assert_equal "BBMB | Passwort ändern", @selenium.get_title
    assert is_element_present("email")
    assert_equal "E-Mail Adresse*", get_text("//label[@for='email']")
    assert is_element_present("pass")
    assert_equal "Passwort*", get_text("//label[@for='pass']")
    assert is_element_present("confirm_pass")
    assert_equal "Bestätigung*", get_text("//label[@for='confirm_pass']")
  end
  def test__duplicate_email
    user = login_customer
    click 'link=Passwort ändern'
    wait_for_page_to_load "30000"

    BBMB.server = flexmock('server')
    BBMB.server.should_receive(:rename_user).times(1).and_return { |old, new|
      raise Yus::YusError, 'duplicate email'
    }
    BBMB.server.should_ignore_missing
    BBMB.persistence.should_ignore_missing

    type "email", "test.user@bbmb.ch"
    type "pass", "secret"
    type "confirm_pass", "secret"

    click "save"
    wait_for_page_to_load "30000"

    assert is_text_present("Es gibt bereits ein Benutzerprofil für diese Email-Adresse")
  end
  def test__missing_data
    user = login_customer
    click 'link=Passwort ändern'
    wait_for_page_to_load "30000"

    BBMB.server = flexmock('server')
    BBMB.server.should_receive(:rename_user)
    BBMB.server.should_ignore_missing
    BBMB.persistence.should_ignore_missing
    user.should_receive(:set_password).and_return { |old, new|
      raise Yus::YusError, 'other error, user not found, privilege problem'
    }

    type "email", ""
    type "pass", ""
    type "confirm_pass", ""

    entity = flexmock('yus-entity')
    entity.should_receive(:valid?).and_return(true)

    click "save"
    wait_for_page_to_load "30000"

    assert is_text_present("Bitte füllen Sie alle Felder aus.")
    assert !is_text_present("Das Passwort war leer")
  end
  def test__password_mismatch
    user = login_customer
    click 'link=Passwort ändern'
    wait_for_page_to_load "30000"

    BBMB.server = flexmock('server')
    BBMB.server.should_receive(:rename_user)
    BBMB.server.should_ignore_missing
    BBMB.persistence.should_ignore_missing
    user.should_receive(:set_password).and_return { |old, new|
      raise Yus::YusError, 'other error, user not found, privilege problem'
    }

    type "email", "test.user@bbmb.ch"
    type "pass", "secret"
    type "confirm_pass", "s3krit"

    entity = flexmock('yus-entity')
    entity.should_receive(:valid?).and_return(true)

    click "save"
    wait_for_page_to_load "30000"

    assert !is_text_present("Bitte füllen Sie alle Felder aus.")
    assert is_text_present("Das Passwort und die Bestätigung waren nicht identisch.")
  end
  def test__password_not_set
    user = login_customer
    click 'link=Passwort ändern'
    wait_for_page_to_load "30000"

    BBMB.server = flexmock('server')
    BBMB.server.should_receive(:rename_user)
    BBMB.server.should_ignore_missing
    BBMB.persistence.should_ignore_missing
    user.should_receive(:set_password).and_return { |old, new|
      raise Yus::YusError, 'other error, user not found, privilege problem'
    }

    type "email", "test.user@bbmb.ch"
    type "pass", "secret"
    type "confirm_pass", "secret"

    entity = flexmock('yus-entity')
    entity.should_receive(:valid?).and_return(true)

    click "save"
    wait_for_page_to_load "30000"

    assert is_text_present("Das Passwort konnte nicht gespeichert werden")
  end
  def test__success
    user = login_customer
    click 'link=Passwort ändern'
    wait_for_page_to_load "30000"

    BBMB.server = flexmock('server')
    BBMB.server.should_receive(:rename_user).times(1)\
      .with('test.customer@bbmb.ch', 'test.user@bbmb.ch').and_return {
      user = mock_user("test.user@bbmb.ch", ['login', 'ch.bbmb.Customer'])
      @server['test:preset-session-id'].force_login(Html::Util::KnownUser.new(user))
    }
    BBMB.server.should_ignore_missing
    BBMB.persistence.should_receive(:save).with(@customer).times(1)
    BBMB.persistence.should_ignore_missing
    user.should_receive(:set_password)

    type "email", "test.user@bbmb.ch"
    type "pass", "secret"
    type "confirm_pass", "secret"

    entity = flexmock('yus-entity')
    entity.should_receive(:valid?).and_return(true)

    click "save"
    wait_for_page_to_load "30000"

    assert is_text_present("Ihre Anmelde-Daten wurden geändert.")
    assert is_text_present("Sie sind angemeldet als test.user@bbmb.ch")

    wait_for_page_to_load "30000"
    assert_equal "BBMB | Warenkorb (Home)", @selenium.get_title
  end
end
  end
end
