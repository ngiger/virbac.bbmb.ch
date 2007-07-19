#!/usr/bin/env ruby
# Html::Util::Lookandfeel -- bbmb.ch -- 15.09.2006 -- hwyss@ywesee.com

require 'sbsm/lookandfeel'

module BBMB
  module Html
    module Util
class Lookandfeel < SBSM::Lookandfeel
  DICTIONARIES = {
    "de"  =>  {
      :additional_info          =>  "Zusatzinformationen",
      :address1                 =>  "Strasse/Nr.",
      :backorder                =>  "im Rückstand",
      :backorder_date           =>  "im Rückstand bis %d.%m.%Y",
      :business_conditions      =>  "Geschäftsbedingungen",
      :business_conditions_text =>  <<-EOS,
Lieferung
Franko für Bestellungen ab Fr. 250.-

Reklamationen sind uns innerhalb von einer Woche nach Erhalt
mitzuteilen.

Preise
Änderungen der Preise oder der Lieferbedingungen bleiben vorbehalten.

Zahlung
30 Tage netto. Je nach Wunsch geht die Verrechnung direkt an den
Besteller oder über die Tierärztliche Verrechnungsstelle (TVS).

Rücksendung
Impfstoffe können aus Gründen der Qualitätssicherung nicht
zurückgenommen werden.
Für andere Präparate kann eine Rücknahme fest verkaufter Ware nur
ausnahmsweise, in unangebrochener Packung, mindestens 6 Monate vor
Verfall und ausschliesslich mit unserer vorherigen Zustimmung
erfolgen.
      EOS
      :calculate                =>  "Berechnen",
      :calculator               =>  "Kalkulieren",
      :calculator_explain       =>  "Kalkulation der Publikumspreise",
      :canton                   =>  "Kanton",
      :catalogue                =>  'Katalog',
      :change_pass              =>  "Passwort ändern",
      :clear_favorites          =>  "Schnellb. löschen",
      :clear_favorites_confirm  =>  "Wollen Sie wirklich die gesamte Schnellbestellung löschen?",
      :clear_order              =>  "Bestellung löschen",
      :clear_order_confirm      =>  "Wollen Sie wirklich die gesamte Bestellung löschen?",
      :cleartext                =>  "Passwort",
      :city                     =>  "Ort",
      :comment                  =>  "Bemerkungen (max. 60 Zeichen)",
      :commit                   =>  "Bestellung auslösen",
      :confirm_pass             =>  "Bestätigung",
      :contact                  =>  "Kontaktperson",
      :currency                 =>  "Sfr.",
      :currency_format          =>  "Sfr. %.2f",
      :current_order            =>  "Warenkorb (Home)",
      :customer                 =>  "Kunde",
      :customers                =>  "Kunden",
      :customer_id              =>  "Kundennr",
      :customer_or_tsv_id       =>  "TVS-Nr. oder Virbac Kunden-Nr.",
      :date_format              =>  "%d.%m.%Y",
      :delete                   =>  "Löschen",
      :delivery_conditions      =>  "Lieferbedingungen",
      :delivery_conditions_text =>  <<-EOS,
Mit der Anmeldung nehme ich die Geschäftsbedingungen zur Kenntnis
und erkläre mich damit einverstanden, dass Produkte und
insbesondere Impfstoffe und Biologika bis spätestens Donnerstag,
14:00 Uhr bestellt werden müssen, um tags darauf geliefert werden
zu können.

Bei Fragen oder Problemen kontaktieren Sie uns bitte unter
<a href="mailto:info@virbac.ch">info@virbac.ch</a> oder 044/809.11.22
      EOS
      :default_values           =>  "Voreinstellungen",
      :drtitle                  =>  "Titel",
      :ean13                    =>  "EAN-Code",
      :email                    =>  "E-Mail Adresse",
      :error                    =>  "Ihre Eingaben konnten nicht gespeichert werden da Angaben fehlen oder nicht korrekt sind.\nBitte ergänzen Sie die rot gekennzeichneten Felder.",
      :e_duplicate_email        =>  "Es gibt bereits ein Benutzerprofil für diese Email-Adresse",
      :e_email_required         =>  "Bitte speichern Sie zuerst eine gültige Email-Adresse",
      :e_empty_pass             =>  "Das Passwort war leer.",
      :e_invalid_ean13          =>  "Der EAN-Code war ungültig.",
      :e_need_all_fields        =>  "Bitte füllen Sie alle Felder aus.",
      :e_non_matching_pass      =>  "Das Passwort und die Bestätigung waren nicht identisch.",
      :e_pass_not_set           =>  "Das Passwort konnte nicht gespeichert werden",
      :e_user_unsaved           =>  "Das Benutzerprofil wurde nicht gespeichert!",
      :factor                   =>  "Bitte Faktor eingeben (z.B. 1.5):",
      :false                    =>  "Nein",
      :favorites                =>  "Schnellbestellung",
      :favorite_positions0      =>  "Aktuelle Schnellbest.: ",
      :favorite_positions1      =>  " Positionen",
      :favorite_product         =>  "Zu Schnellbest. hinzufügen",
      :favorite_transfer        =>  "Datei zu Schnellb.",
      :fax                      =>  "Fax",
      :filter_button            =>  "Filter",
      :firstname                =>  "Vorname",
      :generate_pass            =>  "Passwort Generieren",
      :history                  =>  "Umsatz",
      :history_turnaround0      =>  "Totalumsatz: ",
      :history_turnaround1      =>  "",
      :html_title               =>  "BBMB",
      :increment_order          =>  "Zu Best. hinzufügen",
      :lastname                 =>  "Name",
      :lgpl                     =>  "LGPL",
      :list_price0              =>  '',
      :list_price1              =>  ' Stk. à ',
      :list_price2              =>  '',
      :logged_in_as0            =>  "Sie sind angemeldet als ",
      :logged_in_as1            =>  "",
      :login                    =>  "Anmelden",
      :login_data_saved         =>  "Ihre Anmelde-Daten wurden geändert.",
      :logout                   =>  "Abmelden",
      :logo                     =>  "Virbac",
      :new_customer             =>  "Neuer Kunde",
      :new_customer_mail        =>  "mailto:info@virbac.ch?subject=Neukunde BBMB - bitte Passwort generieren",
      :new_customer_invite      =>  <<-EOS,
Bestellen Sie jetzt online. Wir richten für Sie den auf Ihre Praxis
zugeschnittenen, benutzerfreundlichen E-Shop ein! Unsere Mitarbeiter im
Kundendienst beraten Sie gerne!
      EOS
      :new_customer_thanks      =>  "Besten Dank für Ihre Anfrage.\nIhr Virbac-Team",
      :next                     =>  ">>",
      :nullify                  =>  "Alles auf 0 setzen",
      :order                    =>  "Archiv - Bestellung",
      :orders                   =>  "Archiv",
      :order_problem            =>  <<-EOS,
Beim Versand Ihrer Bestellung ist ein Problem aufgetreten.
Ein Administrator wurde automatisch darüber informiert und wird mit Ihnen Kontakt aufnehmen.
      EOS
      :order_product            =>  "Zu Bestellung hinzufügen",
      :order_sent               =>  "Ihre Bestellung wurde an die Virbac AG versandt.",
      :order_total              =>  "Total (ohne MWSt) Sfr. ",
      :order_transfer           =>  "Datei zu Best.",
      :organisation             =>  "Name Tierarztpraxis",
      :pass                     =>  "Passwort",
      :pager_index0             =>  " ",
      :pager_index1             =>  " bis ",
      :pager_index2             =>  " ",
      :pager_total0             =>  " von ",
      :pager_total1             =>  "",
      :pcode                    =>  "Pharmacode",
      :phone_business           =>  "Tel. Praxis",
      :phone_mobile             =>  "Tel. Mobile",
      :phone_private            =>  "Tel. Privat",
      :plz                      =>  "PLZ",
      :positions0               =>  "Aktuelle Bestellung: ",
      :positions1               =>  " Positionen",
      :previous                 =>  "<<",
      :price_range0             =>  "",
      :price_range1             =>  " bis ",
      :price_range2             =>  "",
      :priority                 =>  "Versandart",
      :priority_0               =>  "Nichts Ausw&auml;hlen",
      :priority_1               =>  "Post",
      :priority_13              =>  "Express Mond",
      :priority_16              =>  "Express Freitag",
      :priority_21              =>  "Kurier",
      :priority_40              =>  "Terminfracht",
      :priority_41              =>  "Terminfracht",
      :priority_explain_1       =>  "Lieferung n&auml;chster Tag (gem. Konditionenliste)",
      :priority_explain_13      =>  "Lieferung Vormittag n&auml;chster Tag (z.L. Kunde)",
      :priority_explain_16      =>  "Lieferung am Samstag (z.L. Kunde)",
      :priority_explain_21      =>  "Lieferung am gleichen Tag (z.L. Kunde)",
      :priority_explain_40      =>  "bis 09:00 Uhr / 80 Sfr. (z.L. Kunde)",
      :priority_explain_41      =>  "bis 10:00 Uhr / 50 Sfr. (z.L. Kunde)",
      :product_found            =>  "Suchresultat: 1 Produkt gefunden",
      :products_found0          =>  "Suchresultat: ",
      :products_found1          =>  " Produkte gefunden",
      :promotion                =>  "P",
      :promotion_explain        =>  "<b>Promotion:</b>",
      :promotions               =>  "Promotionen",
      :quotas                   =>  "Abschlüsse",
      :reference                =>  "Interne Bestellnummer",
      :request_access           =>  "Anfrage Abschicken",
      :request_sent             =>  <<-EOS,
Ihre Anfrage wurde erfolgreich abgeschickt. Sie wird geprüft und innerhalb eines Werktags verarbeitet.
Beste Grüsse. Virbac Schweiz AG
      EOS
      :reset                    =>  "Zurücksetzen",
      :sale                     =>  "A",
      :sale_explain             =>  "<b>Aktion:</b>",
      :save                     =>  "Speichern",
      :search                   =>  "Suchen",
      :search_favorites         =>  "Suchen",
      :show_pass                =>  "Passwort Anzeigen",
      :show_vat                 =>  "inkl. MwSt.",
      :th_actual                =>  "Menge fakt.",
      :th_catalogue1            =>  "Katalog",
      :th_city                  =>  "Ort",
      :th_commit_time           =>  "Bestellung vom",
      :th_customer_id           =>  "Kundennr",
      :th_description           =>  "Artikelbezeichnung",
      :th_difference            =>  "Menge offen",
      :th_end_date              =>  "Gültig bis",
      :th_email                 =>  "Email",
      :th_exclusive             =>  'exkl. MwSt.',
      :th_expiry_date           =>  'Verfalldatum',
      :th_item_count            =>  "Packungen",
      :th_last_login            =>  "Letztes Login",
      :th_order_count           =>  "Best.",
      :th_price                 =>  "Listenpreis",
      :th_price_base            =>  "Listenpreis",
      :th_price_levels          =>  'Staffelpreise',
      :th_price_public          =>  "Publikumspreis",
      :th_quantity              =>  'Menge', 
      :th_order_total           =>  "Endpreis",
      :th_organisation          =>  "Kunde",
      :th_plz                   =>  "PLZ",
      :th_promotion_date        =>  "Gültig bis",
      :th_promotion_lines       =>  "Promotion",
      :th_sale_date             =>  "Gültig bis",
      :th_sale_lines            =>  "Aktion",
      :th_size                  =>  "Positionen",
      :th_start_date            =>  "Gültig von",
      :th_target                =>  "Sollmenge",
      :th_total                 =>  "Total",
      :th_valid                 =>  "Aktiviert",
      :th_vat                   =>  "MwSt.",
      :th_vat_value             =>  "Betrag",
      :title                    =>  "Anrede",
      :title_f                  =>  "Frau",
      :title_m                  =>  "Herr",
      :true                     =>  "Ja",
      :turnaround               =>  "Umsatz",
      :unavailable0             =>  "Unidentifiziertes Produkt (",
      :unavailable1             =>  ")",
      :version                  =>  "Commit-ID",
      :welcome                  =>  "Wilkommen bei Virbac",
      :ywesee                   =>  "ywesee.com",
    },
    "fr"  =>  {
      :additional_info          =>  "Informations supplémentaires",
      :address1                 =>  "Rue/n°",
      :backorder                =>  "en rupture",
      :backorder_date           =>  "en rupture jusqu'au",
      :business_conditions      =>  "Conditions générales",
      :business_conditions_text =>  <<-EOS,
Livraison
Sans frais de port dès une commande de Fr. 250.--

Les réclamations doivent nous parvenir dans les 8 jours suivant la
réception de la marchandise.

Prix
Les prix ainsi que les conditions de livraison peuvent être
modifiés en tout temps.

Paiement
30 jour net. La facturation se fait selon le souhait du client,
soit directement au client ou par l'intermédiaire de l'OGV.

Retours
Les vaccins ne sont pas repris afin de respecter les normes de
qualité.
Pour les autres produits, un retour n'est possible
qu'exceptionnellement, à conditions que la marchandise ne soit pas
entamée, au moins 6 mois avant la date de péremption et
exclusivement avec notre accord
      EOS
      :calculate                =>  "Calculer",
      :calculator               =>  "Calculer",
      :calculator_explain       =>  "Calcul des prix publics",
      :canton                   =>  "Canton",
      :catalogue                =>  "Catalogue",
      :change_pass              =>  "Changer mot de passe",
      :clear_favorites          =>  "Supprimer commande rapide",
      :clear_favorites_confirm  =>  "Voulez-vous vraiment supprimer toute la commande rapide?",
      :clear_order              =>  "Supprimer la commande",
      :clear_order_confirm      =>  "Voulez-vous vraiment supprimer toute la commande?",
      :cleartext                =>  "Mot de passe",
      :city                     =>  "Lieu",
      :comment                  =>  "Commentaires (max. 60 signes)",
      :commit                   =>  "Passer la commande",
      :confirm_pass             =>  "Confirmation",
      :contact                  =>  "Personne de contact",
      :currency                 =>  "CHF",
      :currency_format          =>  "CHF",
      :current_order            =>  "Panier (home)",
      :customer                 =>  "Client",
      :customers                =>  "Clients",
      :customer_id              =>  "No. de client",
      :customer_or_tsv_id       =>  "No. TVA ou no. de client Virbac",
      :date_format              =>  "%d.%m.%Y",
      :delete                   =>  "Supprimer",
      :delivery_conditions      =>  "Conditions de livraison",
      :delivery_conditions_text =>  <<-EOS,
Par mon inscription je prends connaissance des conditions générales
et je confirme que je suis d'accord que les produits, dont surtout
les vaccins et produits biologiques, doivent être commandés
jusqu'au jeudi 14 h 00 au plus tard, pour pouvoir être livrés le
lendemain.

Pour toute question ou tout problème, veuillez nous contacter sous
<a href="mailto:info@virbac.ch">info@virbac.ch</a> ou au 044/809.11.22
      EOS
      :default_values           =>  "Revenir au début",
      :drtitle                  =>  "Titre",
      :ean13                    =>  "Code EAN",
      :email                    =>  "Adresse e-mail",
      :error                    =>  "Votre ordre n'a pas été enregistré par manque de données ou données incorrectes.\nVeuillez compléter les champs marqués en rouge",
      :e_duplicate_email        =>  "Il existe déjà un profil d'utilisation pour cette adresse email",
      :e_email_required         =>  "Veuillez d'abord enregistrer une adresse e-mail valable",
      :e_empty_pass             =>  "Le mot de passe était vide",
      :e_invalid_ean13          =>  "Le code EAN était invalide",
      :e_need_all_fields        =>  "Veuillez remplir tous les champs",
      :e_non_matching_pass      =>  "Le mot de passe et la confirmation n'étaient pas identiques",
      :e_pass_not_set           =>  "Le mot de passe n'a pas pu être enregistré",
      :e_user_unsaved           =>  "Le profil d'utilisation n'a pas été enregistré",
      :factor                   =>  "Veuillez entrer un facteur (p.ex. 1.5)",
      :false                    =>  "Non",
      :favorites                =>  "Commande rapide",
      :favorite_positions0      =>  "Commande rapide actuelle",
      :favorite_positions1      =>  "Positions",
      :favorite_product         =>  "Ajouter à la commande rapide",
      :favorite_transfer        =>  "Fichier pour commande rapide",
      :fax                      =>  "Fax",
      :filter_button            =>  "Filtre",
      :firstname                =>  "Prénom",
      :generate_pass            =>  "Générer un mot de passe",
      :history                  =>  "Chiffre d'affaires",
      :history_turnaround0      =>  "Chiffre d'affaires total",
      :history_turnaround1      =>  "",
      :html_title               =>  "BBMB",
      :increment_order          =>  "Ajouter à la commande",
      :lastname                 =>  "Nom",
      :lgpl                     =>  "LGPL",
      :list_price0              =>  '',
      :list_price1              =>  "Articles à",
      :list_price2              =>  '',
      :logged_in_as0            =>  "Vous êtes inscrits sous",
      :logged_in_as1            =>  "",
      :login                    =>  "S'inscrire",
      :login_data_saved         =>  "Vos coordonnées d'inscription ont été modifées",
      :logout                   =>  "Quitter",
      :logo                     =>  "Virbac",
      :new_customer             =>  "Nouveau client",
      :new_customer_mail        =>  "mailto:info@virbac.ch?subject=Neukunde_BBMB - Générer un mot de passe svp",
      :new_customer_invite      =>  <<-EOS,
Commandez maintenant en ligne. Nous mettons à votre disposition un shop en
ligne convivial et conçu pour votre cabinet! Nos collaborateurs du service
clientèle vous conseillent volontiers.
       EOS
      :new_customer_thanks      =>  "Merci pour votre demande.\nVotre team Virbac",
      :next                     =>  ">>",
      :nullify                  =>  "Mettre tout à 0",
      :order                    =>  "Commande archives",
      :orders                   =>  "Archives",
      :order_problem            =>  <<-EOS,
Un problème a été rencontré lors de l'envoi de votre commande. Un
administrateur a automatiquement été informé et prendra contact avec vous.
       EOS
      :order_product            =>  "Ajouter à la commande",
      :order_sent               =>  "Votre commande a été envoyé à Virbac SA",
      :order_total              =>  "Total (hors TVA) CHF",
      :order_transfer           =>  "Coordonnées pour commande",
      :organisation             =>  "Nom du cabinet vétérinaire",
      :pass                     =>  "Mot de passe",
      :pager_index0             =>  " ",
      :pager_index1             =>  "Jusqu'au",
      :pager_index2             =>  " ",
      :pager_total0             =>  "de",
      :pager_total1             =>  "",
      :pcode                    =>  "Pharmacode",
      :phone_business           =>  "Tél. du cabinet",
      :phone_mobile             =>  "Tél. mobile",
      :phone_private            =>  "Tél. privé",
      :plz                      =>  "NPA",
      :positions0               =>  "Commande actuelle",
      :positions1               =>  "Positions",
      :previous                 =>  "<<",
      :price_range0             =>  "",
      :price_range1             =>  "jusqu'au",
      :price_range2             =>  "",
      :priority                 =>  "Mode de livraison",
      :priority_0               =>  "Ne rien choisir",
      :priority_1               =>  "Par poste",
      :priority_13              =>  "Par express lune",
      :priority_16              =>  "Par express le vendredi",
      :priority_21              =>  "Par coursier",
      :priority_explain_1       =>  "Livraison le lendemain",
      :priority_explain_13      =>  "Livraison le lendemain matin (à la charge du client)",
      :priority_explain_16      =>  "Livraison le samedi (à la charge du client)",
      :priority_explain_21      =>  "Livraison le jour même (à la charge du client)",
      :product_found            =>  "Résultat de recherche: 1 produit trouvé",
      :products_found0          =>  "Résultat de recherche:",
      :products_found1          =>  "Produits trouvés",
      :promotion                =>  "P",
      :promotion_explain        =>  "<b>Promotion:</b>",
      :promotions               =>  "Actions",
      :quotas                   =>  "Contrats",
      :reference                =>  "No. de commande interne",
      :request_access           =>  "Envoyer la demande",
      :request_sent             =>  <<-EOS,
Votre demande a été envoyée avec succès. Elle sera contrôlée et traitée en
un jour ouvrable. Meilleures salutations. Virbac Suisse SA
       EOS
      :reset                    =>  "Revenir en arrière",
      :sale                     =>  "A",
      :sale_explain             =>  "<b>Aktion:</b>",
      :save                     =>  "Sauvegarder",
      :search                   =>  "Chercher",
      :search_favorites         =>  "Chercher",
      :show_pass                =>  "Signaler mot de passe",
      :show_vat                 =>  "incl. TVA",
      :th_actual                =>  "Quantité fact.",
      :th_catalogue1            =>  "Catalogue",
      :th_city                  =>  "Lieu",
      :th_commit_time           =>  "Commande du",
      :th_customer_id           =>  "No. de client",
      :th_description           =>  "Description de l'article",
      :th_difference            =>  "Quantité en suspens",
      :th_end_date              =>  "valable jusqu'au",
      :th_email                 =>  "Email",
      :th_exclusive             =>  "excl. TVA",
      :th_expiry_date           =>  "Péremption",
      :th_item_count            =>  "Emballages",
      :th_last_login            =>  "Dernier login",
      :th_order_count           =>  "Commandé",
      :th_price                 =>  "Prix de liste",
      :th_price_base            =>  "Prix de liste",
      :th_price_levels          =>  "Prix selon quantité",
      :th_price_public          =>  "Prix public",
      :th_quantity              =>  "Quantité",
      :th_order_total           =>  "Montant total",
      :th_organisation          =>  "Client",
      :th_plz                   =>  "NPA",
      :th_promotion_date        =>  "Valable jusqu'au",
      :th_promotion_lines       =>  "Action",
      :th_sale_date             =>  "Valable jusqu'au",
      :th_sale_lines            =>  "Aktion",
      :th_size                  =>  "Positions",
      :th_start_date            =>  "Valable du",
      :th_target                =>  "Quantité dû",
      :th_total                 =>  "Total",
      :th_valid                 =>  "Activé",
      :th_vat                   =>  "TVA",
      :th_vat_value             =>  "Montant",
      :title                    =>  "Coordonnées",
      :title_f                  =>  "Madame",
      :title_m                  =>  "Monsieur",
      :true                     =>  "Oui",
      :turnaround               =>  "Chiffre d'affaires",
      :unavailable0             =>  "Produit non identifié",
      :unavailable1             =>  ")",
      :version                  =>  "Commit-ID",
      :welcome                  =>  "Bienvenue chez Virbac",
      :ywesee                   =>  "ywesee.com",
    },
  }
  RESOURCES = {
    :activex    => 'activex',
    :css        => 'bbmb.css',
    :dojo_js    => 'dojo/dojo.js',
    :javascript => 'javascript',
    :logo       => 'logo.gif',
  }
  DISABLED = [ :transfer_dat, :barcode_reader ]
  ENABLED = [ :request_access ]
  def navigation
    zone_navigation + super
  end
end
    end
  end
end
