# sandozxmlconv

* https://github.com/zdavatz/virbac.bbmb.ch


## DESCRIPTION:

* virbac.bbmb.ch

## REQUIREMENTS:

* bbmb - sudo gem install bbmb

## INSTALL:

* git clone https://github.com/zdavatz/virbac.bbmb.ch.git
* create and adapt etc/polling.yml
* create and adapt etc/ydim.yml
* create and adapt etc/yus.yml
* create and adapt etc/conf.yml
* mkdir -p log var/output
* integrate it with apache mod_ruby

## Testing

niklaus@oddb-ci2 /v/w/virbac.bbmb.ch> bin/admin
ch.bbmb> BBMB.config.auth_domain
-> ch.bbmb.vetoquinol
ch.bbmb> exit
-> Goodbye
niklaus@oddb-ci2 /v/w/virbac.bbmb.ch> bin/admin config=/var/www/virbac.bbmb.ch/etc/config.yml
ch.bbmb.virbac> BBMB.config.auth_domain
-> ch.bbmb.virbac

## DEVELOPERS:

* Zeno R.R. Davatz
* Masaomi Hatakeyama
* Hannes Wyss (up to Version 1.0.0)
* Niklaus Giger (ported to Ruby 2.3)

## LICENSE:

* GPLv2
