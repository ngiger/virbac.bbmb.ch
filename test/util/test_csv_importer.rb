#!/usr/bin/env ruby
# Util::TestCsvImporter -- bbmb -- 10.04.2007 -- hwyss@ywesee.com

$: << File.expand_path('../../lib', File.dirname(__FILE__))
$: << File.expand_path('..', File.dirname(__FILE__))

require 'test/unit'
require 'bbmb/util/csv_importer'
require 'stub/persistence'
require 'flexmock'
require 'stringio'

module BBMB
  module Util
    class TestCsvImporter < Test::Unit::TestCase
      def test_string
        importer = CsvImporter.new
        assert_nil(importer.string(''))
        assert_equal(u("äöü"), importer.string("\344\366\374"))
      end
    end
    class TestCustomerImporter < Test::Unit::TestCase
      include FlexMock::TestCase
      def setup
        Model::Customer.clear_instances
        BBMB.server = flexmock('server')
        BBMB.server.should_ignore_missing
      end
      def test_import
        src = StringIO.new <<-EOS
"Kunden-Nr.","Status","Name1","Name2","PLZ","Ort","Strasse","E-Mail","Sprache","Kanton"
3000,"A","Axxxxxxx Wxxxxxxx","Vxxxxxxxxxx","2000","Nxxxxxxxx","19, Bxxxx-Axxx","xxxxxxxxxx@xxxxxxxx.xx","x ","NE",
3002,"A","Cxxxxx Fxxxxxxxx","Vxxxxxxxxxx","1305","Pxxxxxxxx","10, xx. xx Sxxxxx","xxx.xxxxxx@xxxxxxx.xx","x ","VD",
3004,"A","Txxxxxxxxxxxxx Rxxxxxxxx AG","","3254","Mxxxxx","Rxxxxxxxx 14","xxxxxxxxxx@xxxxxx.xx","x ","SO",
3005,"A","Axxxx Pxxxx","Kxxxx- & Zxxxxxxxxxxxx","8507","Hxxxxxxxx","Sxxxxxxxxxxx","xxxxx.xxx@xxxxxxx.xx","x ","TG",
3006,"A","Bxxxxxx W.","Txxxxxxx","3800","Mxxxxx x. Ixxxxxxxxx","Hxxxxxxx. 37","xxxxxxxx@xxxxxxx.xx","x ","BE4",
3007,"A","Axxxxxxxxx Cxxxxxxxx & Sxxxxx","","6430","Sxxxxx","Hxxxxxxx Sxxxxxxxx 24","x.xxxxxx@xxxxxxx.xx","x ","SZ",
3008,"A","Dxxx.xxx.xxx.","R.Pxxx & G.Rxxx & V. Ixxxxx","7000","Cxxx","Hxxxxxxxx 5","xxxx.xxxx@xxxxxxx.xx","x ","GR",
3009,"A","Bxxxxx Pxxxxxxx","Vxxxxxxxxxx","1814","Lx Txxx-xx-Pxxxx","Ax. xx Cxxx-D'Axxxxxx 38","xx.xxxxxx@xxxxxxxx.xx","x ","VD",
3010,"A","Bxxxxxxxx Bxxxxxxx","Txxxxxxx","5274","Mxxxxx","Txxxxxxxx 111","xxxxxxxx.xxxxxxxxx@xxxxxxx.xx","x ","AG2",
3011,"A","Cxxxx Lxxxx","Txxxxxxx","4106","Txxxxxx","Bxxxxxxxxxxxx 6","I.Cxxxx@xxxxxxx.xx","x ","BL",
        EOS
        persistence = flexmock("persistence")
        persistence.should_receive(:save).times(10).and_return { |customer|
          assert_instance_of(Model::Customer, customer)
        }
        CustomerImporter.new.import(src, persistence)
      end
      def test_import_record
        line = StringIO.new <<-EOS
"Kunden-Nr.","Status","Name1","Name2","PLZ","Ort","Strasse","E-Mail","Sprache","Kanton"
3000,"A","Axxxxxxx Wxxxxxxx","Vxxxxxxxxxx","2000","Nxxxxxxxx","19, Bxxxx-Axxx","xxxxxxxxxx@xxxxxxxx.xx","d ","NE",
        EOS
        importer = CustomerImporter.new
        persistence = flexmock("persistence")
        persistence.should_receive(:save).times(1)\
          .and_return { |customer|
          assert_instance_of(Model::Customer, customer)
          assert_equal(:active, customer.status)
          assert_equal("de", customer.language)
          assert_equal("3000", customer.customer_id)
          assert_equal("Axxxxxxx Wxxxxxxx", customer.organisation)
          assert_equal("Vxxxxxxxxxx", customer.address1)
          assert_equal("19, Bxxxx-Axxx", customer.address2)
          assert_equal("2000", customer.plz)
          assert_equal("Nxxxxxxxx", customer.city)
          assert_equal("xxxxxxxxxx@xxxxxxxx.xx", customer.email)
        }
        importer.import(line, persistence)
      end
      def test_import_record__protected
        line = StringIO.new <<-EOS
"Kunden-Nr.","Status","Name1","Name2","PLZ","Ort","Strasse","E-Mail","Sprache","Kanton"
3000,"A","Axxxxxxx Wxxxxxxx","Vxxxxxxxxxx","2000","Nxxxxxxxx","19, Bxxxx-Axxx","xxxxxxxxxx@xxxxxxxx.xx","x ","NE",
        EOS
        customer = Model::Customer.new("3000")
        customer.address2 = 'corrected line'
        customer.protect!(:address2)
        importer = CustomerImporter.new
        persistence = flexmock("persistence")
        persistence.should_receive(:save).times(1)\
          .and_return { |customer|
          assert_instance_of(Model::Customer, customer)
          assert_equal("3000", customer.customer_id)
          assert_equal("Axxxxxxx Wxxxxxxx", customer.organisation)
          assert_equal("Vxxxxxxxxxx", customer.address1)
          assert_equal("corrected line", customer.address2)
          assert_equal("2000", customer.plz)
          assert_equal("Nxxxxxxxx", customer.city)
          assert_equal("xxxxxxxxxx@xxxxxxxx.xx", customer.email)
        }
        importer.import(line, persistence)
      end
    end
    class TestProductImporter < Test::Unit::TestCase
      include FlexMock::TestCase
      def setup
        Model::Product.clear_instances
      end
      def test_import
        src = StringIO.new <<-EOS
"Artikel-Nr.","Status","Bezeichnung","Menge 1","Preis 1","Menge 2","Preis 2","Menge 3","Preis 3","Menge 4","Preis 4","Menge 5","Preis 5","MWST","EAN","Katalogtext 1","Katalogtext 2","Katalogtext 3","Verfallsdatum","Promotext 1","Promotext 2","Promotext 3","Promotext 4","Gültig von","Gültig bis","Aktionstext 1","Aktionstext 2","Aktionstext 3","Aktionstext 4","Gültig von","Gültig bis"
100789,"A","Chronomintic Applikator",   1,    32.00,   0,     0.00,   0,     0.00,   0,     0.00,   0,     0.00,"2","","Großtiere","Antiparasitika","Chronomintic Applikator                 ","","","","","","","","","","","","","",
102259,"A","Spritze 2ml",   1,     0.00,   0,     0.00,   0,     0.00,   0,     0.00,   0,     0.00,"2","","Kleintiere","Immunologika","Spritze 2ml                             ","","","","","","","","","","","","","",
102260,"A","Nadel violett 0.55 x 25mm",   1,     0.00,   0,     0.00,   0,     0.00,   0,     0.00,   0,     0.00,"2","","Kleintiere","Immunologika","Nadel violett                           ","","","","","","","","","","","","","",
104769,"A","Impfzeugnis für Katzen",   1,     0.00,   0,     0.00,   0,     0.00,   0,     0.00,   0,     0.00,"2","","Kleintiere","Immunologika","Impfzeugnis für Katzen                  ","","","","","","","","","","","","","",
104771,"A","Impfzeugnisse für Hunde",   1,     0.00,   0,     0.00,   0,     0.00,   0,     0.00,   0,     0.00,"2","","Kleintiere","Immunologika","Impfzeugnis für Hunde                   ","","","","","","","","","","","","","",
104777,"A","Parasitenpass für Hund/Katze",   1,     0.00,   0,     0.00,   0,     0.00,   0,     0.00,   0,     0.00,"2","","Kleintiere","Antiparasitika","Parasitenpass für Hund/Katze            ","","","","","","","","","","","","","",
109900,"A","ETUI für Impfzeugnisse blau",   1,     0.00,   0,     0.00,   0,     0.00,   0,     0.00,   0,     0.00,"2","","Kleintiere","Immunologika","Etui für Impfzeugnisse blau             ","","","","","","","","","","","","","",
300355,"A","Sebomild P Lotion 250ml",   1,    12.75,  12,    12.00,  36,    11.20,   0,     0.00,   0,     0.00,"2","7640118780567","Kleintiere","Dermatologika","Sebomild P Lotion                       ","31.03.2008","","","","","","","","","","","","",
300359,"A","Sebomild P  Shampoo 200ml",   1,    12.75,  12,    12.00,  36,    11.20,   0,     0.00,   0,     0.00,"2","7640118780574","Kleintiere","Dermatologika","Sebomild P Shampoo                      ","30.11.2008","","","","","","","","","","","","",
300360,"A","Energan Azidose 12 Patronen",   1,    99.50,   3,    94.50,   6,    88.50,   0,     0.00,   0,     0.00,"1","","Großtiere","Stoffwechsel","Energan Azidose                         ","30.09.2007","","","","","","","","","","","","",
        EOS
        persistence = flexmock("persistence")
        persistence.should_receive(:save).times(10).with(Model::Product)
        ProductImporter.new.import(src, persistence)
      end
      def test_import_record
        line = StringIO.new <<-EOS
"Artikel-Nr.","Status","Bezeichnung","Menge 1","Preis 1","Menge 2","Preis 2","Menge 3","Preis 3","Menge 4","Preis 4","Menge 5","Preis 5","MWST","EAN","Katalogtext 1","Katalogtext 2","Katalogtext 3","Verfallsdatum","Promotext 1","Promotext 2","Promotext 3","Promotext 4","Gültig von","Gültig bis","Aktionstext 1","Aktionstext 2","Aktionstext 3","Aktionstext 4","Gültig von","Gültig bis"
300355,"A","Sebomild P Lotion 250ml",   1,    12.75,  12,    12.00,  36,    11.20,   0,     0.00,   0,     0.00,"2","7640118780567","Kleintiere","Dermatologika","Sebomild P Lotion                       ","31.03.2008","","","","","","","","","","","","",
        EOS
        persistence = flexmock("persistence")
        persistence.should_receive(:save).and_return { |product|
          assert_instance_of(Model::Product, product)
          assert_equal("300355", product.article_number)
          assert_equal(:active, product.status)
          assert_equal("Sebomild P Lotion 250ml", product.description)
          assert_equal(12.75, product.price)
          assert_equal(12, product.l1_qty)
          assert_equal(12.00, product.l1_price)
          assert_equal(36, product.l2_qty)
          assert_equal(11.20, product.l2_price)
          assert_equal(0, product.l3_qty)
          assert_equal(nil, product.l3_price)
          assert_equal(0, product.l4_qty)
          assert_equal(nil, product.l4_price)
          assert_equal(2, product.mwst)
          assert_equal("7640118780567", product.ean13)
          assert_nil(product.pcode)
          assert_equal('Kleintiere', product.catalogue1)
          assert_equal('Dermatologika', product.catalogue2)
          assert_equal('Sebomild P Lotion', product.catalogue3)
          assert_equal('31.03.2008', product.expiry_date)
          assert_nil(product.sale)
          assert_nil(product.promotion)
        }
        ProductImporter.new.import(line, persistence)
      end
      def test_import_record__promotion
        line = StringIO.new <<-EOS
"Artikel-Nr.","Status","Bezeichnung","Menge 1","Preis 1","Menge 2","Preis 2","Menge 3","Preis 3","Menge 4","Preis 4","Menge 5","Preis 5","MWST","EAN","Katalogtext 1","Katalogtext 2","Katalogtext 3","Verfallsdatum","Promotext 1","Promotext 2","Promotext 3","Promotext 4","Gültig von","Gültig bis","Aktionstext 1","Aktionstext 2","Aktionstext 3","Aktionstext 4","Gültig von","Gültig bis"
301003,"A","Starke Gr\374ne Salbe  450g",   1,    10.10,  12,     9.50,  36,     9.20,  60,     8.55,   0,     0.00,"1","7640118780598","Gro\337tiere","Antiphlogistika","Starke Gr\374ne Salbe 450g                 ","30.09.2010","Beim Kauf von 12 x 450g = 1 x 450g Bonus","Beim Kauf von 36 x 450g = 4 x 450g Bonus","Beim Kauf von 60 x 450g = 8 x 450g Bonus","","01.03.2007","30.04.2007","","","","","","",
        EOS
        persistence = flexmock("persistence")
        persistence.should_receive(:save).and_return { |product|
          assert_instance_of(Model::Product, product)
          assert_equal("301003", product.article_number)
          assert_equal(:active, product.status)
          assert_equal("Starke Grüne Salbe 450g", product.description)
          assert_equal(10.10, product.price)
          assert_equal(12, product.l1_qty)
          assert_equal(9.50, product.l1_price)
          assert_equal(36, product.l2_qty)
          assert_equal(9.20, product.l2_price)
          assert_equal(60, product.l3_qty)
          assert_equal(8.55, product.l3_price)
          assert_equal(0, product.l4_qty)
          assert_equal(nil, product.l4_price)
          assert_equal(1, product.mwst)
          assert_equal("7640118780598", product.ean13)
          assert_nil(product.pcode)
          assert_equal('Großtiere', product.catalogue1)
          assert_equal('Antiphlogistika', product.catalogue2)
          assert_equal('Starke Grüne Salbe 450g', product.catalogue3)
          assert_equal('30.09.2010', product.expiry_date)
          promo = product.promotion
          assert_instance_of(Model::Promotion, promo)
          lines = [
            "Beim Kauf von 12 x 450g = 1 x 450g Bonus",
            "Beim Kauf von 36 x 450g = 4 x 450g Bonus",
            "Beim Kauf von 60 x 450g = 8 x 450g Bonus",
          ]
          assert_equal(lines, promo.lines)
          assert_equal(Date.new(2007, 3, 1), promo.start_date)
          assert_equal(Date.new(2007, 4, 30), promo.end_date)
          assert_nil(product.sale)
        }
        ProductImporter.new.import(line, persistence)
      end
    end
  end
end
