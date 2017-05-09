# Manual tests

The following manual test should be run:
* Run the importer with a call like
  bundle exec bin/update_abschluss_artikel_artikel_fr_kunden
* Set in etc/config.yml the update_hour to the next hour and verify that the import start

* login as a normal user
  The home Warenkorb should appear with a least of product
** visiting the following links should work
*** Warenkorb (Home)
*** Archiv
*** Schnellbestellung
*** Katalog
*** Abschlüsse
*** Promotionen
*** Kalkulieren
*** Passwort ändern
*** Abmelden
After selecting abmelden the link "Abmelden" should no longer appear.

* login as admin user
** All customers should appear
** Search via name/id/address should work
** Changing the language to french and back should work
** Select a user and
*** Changing a street address (and other fields should work). Values should persist after restarting the app
*** Change the password
*** Generate a new password
** Clicking on Umsatz should display a list of orders (total should match)
