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
*** For a normal user Claude and user Perk test that
**** you can find them via the search
**** you can select then
**** when clicking on "Umsatz" you see a list of article with prices and total
**** when clicking on numerical value of Umsatz you see a list of orders.
**** Click on an order and you must see the items orders with name, list price, effective price, total, MWSt
** Search via name/id/address should work
** Changing the language to french and back should work
** Select a user and
*** Changing a street address (and other fields should work). Values should persist after restarting the app
*** Change the password
*** Generate a new password
** Clicking on Umsatz should display a list of orders (total should match)

* Test the admin interface
  sudo -u bbmb bundle exec bin/virbac_admin
  Verify it with the following commands

  ch.bbmb.virbac> ODBA.cache.extent(BBMB::Model::Order).size
  -> 10747
  ch.bbmb.virbac> ODBA.cache.extent(BBMB::Model::Customer).size
  -> 3324
