# Manual tests

The following manual test should be run:
* Run the importer with a call like
  sudo -u bbmb bundle exec bin/update_abschluss_artikel_artikel_fr_kunden
* Set in etc/config.yml the update_hour to the next hour and verify that the import start

* login as a normal user
  The home Warenkorb should appear with a least of product
** visiting the following links should work
*** Warenkorb (Home)
*** Archiv
*** Schnellbestellung
**** Adding an item via Suchen must work
**** Deleting an itme must work
*** Katalog
**** Test whether you can add an item to a Bestellung
*** Abschlüsse
*** Promotionen
**** Test whether you can add a HPM item to the Schnellbestellung
*** Kalkulieren
**** Test whether changing the factor works
*** Passwort ändern
*** Abmelden
After selecting abmelden the link "Abmelden" should no longer appear.

* login as admin user
** All customers should appear
*** You must be able to sort each column by clicking on the column header. Clicking a second time must invert the search order
*** For a normal user Claude and user Perk test that
**** you can find them via the search
**** you can select then
**** when clicking on "Umsatz" you see a list of article with prices and total
**** when clicking on numerical value of Umsatz you see a list of orders.
**** Click on an order and you must see the items orders with name, list price, effective price, total, MWSt
*** Submit an order
**** Check that it landed in directory specified via the order_destinations in etc/config.yml, eg. via
     order_destinations:
        - "file:///var/www/virbac.bbmb.ch/order_destinations"
** Search via name/id/address should work
** Changing the language to french and back should work
** Select a user and
*** Changing a street address (and other fields should work). Values should persist after restarting the app
*** Change the password
*** Generate a new password
*** Change the e-mail
**** When the email is not empty, it should not to possible to save an empty password
**** When setting it to the e-mail of another customer, this change must be refused
** Clicking on Umsatz should display a list of orders (total should match)

* Test the admin interface. But first add the following lines to your etc/config.yml
  mail_suppress_sending: true
  order_destinations:
    - "file:///var/www/virbac.bbmb.ch/dummy_order_destinations"

** Here is a replay of session
  sudo -u bbmb bundle exec bin/virbac_admin
  Verify it with the following commands

  ch.bbmb.virbac> ODBA.cache.extent(BBMB::Model::Order).size
  -> 10747
  ch.bbmb.virbac> ODBA.cache.extent(BBMB::Model::Customer).size
  -> 3324
  ch.bbmb.virbac>update
  ch.bbmb.virbac>invoice(Time.now-24*60*60..Time.now)
  ch.bbmb.virbac> invoice(Time.now-24*60*60..Time.now)
  -> /home/niklaus/git/bbmb/lib/bbmb/util/mail.rb:61 Suppress sending mail with subject: Bbmb(Virbac): No invoice necessary
  from orders.virbac@bbmb.ch to: ["ngiger@ywesee.com"] cc: [] reply_to:
  Baseline:      3000000.00
  Turnover:            0.00
  Current Month:       0.00
  -------------------------
  Outstanding:   3000000.00
  Mail::Message
  ch.bbmb.virbac>exit
  -> Goodby
