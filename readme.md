# sandozxmlconv

* https://github.com/zdavatz/sandoz.xmlconv.bbmb.ch

A graphical overview can be found here:

* https://github.com/zdavatz/sandoz.xmlconv.bbmb.ch/sandozxmlconv.jpeg

## DESCRIPTION:

* xml converter files for Sandoz Switzerland

## REQUIREMENTS:

* xmlconv - sudo gem install xmlconv

## INSTALL:

* git clone https://github.com/zdavatz/sandoz.xmlconv.bbmb.ch.git
* create and adapt etc/polling.yml
* create and adapt etc/xmlconv.yml
* mkdir -p log var/output
* integrate it with apache mod_ruby

## Testing

There is one spec test (using watir) to check the injection. To run it call `rspec spec/injection_spec.rb`

## DEVELOPERS:

* Zeno R.R. Davatz
* Masaomi Hatakeyama
* Hannes Wyss (up to Version 1.0.0)
* Niklaus Giger (ported to Ruby 2.3)

## LICENSE:

* GPLv2
