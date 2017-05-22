#!/usr/bin/env ruby
# Util::TestUpdater -- bbmb.ch -- 14.09.2006 -- hwyss@ywesee.com

$: << File.expand_path('..', File.dirname(__FILE__))
$: << File.expand_path('../../lib', File.dirname(__FILE__))

require "minitest/autorun"
require 'flexmock/test_unit'
require 'bbmb/util/updater'
require 'bbmb/util/csv_importer'
require 'stub/persistence'

module BBMB

  module Util
    class TestUpdater < Minitest::Test
      include FlexMock::TestCase
      def setup
        load File.join($:.find{|x| /gems\/bbmb/.match(x) }, 'bbmb/config.rb')
        BBMB.config.importers = {
          'ABSCHLUSS.CSV' => 'QuotaImporter',
          'ARTIKEL.CSV'   => ['ProductImporter', :de],
          'ARTIKEL_FR.CSV'   => ['ProductImporter', :fr],
          'KUNDEN.CSV'    => 'CustomerImporter',
        }
      end
      def teardown
        BBMB.config = nil
        super
      end
      def test_import_customers
        persistence = flexmock("persistence")
        flexstub(CustomerImporter).should_receive(:new).times(1).and_return {
          importer = flexmock('importer')
          importer.should_receive(:import).times(1).and_return { |io|
            assert_equal('data', io)
          }
          importer
        }
        Updater.import("CustomerImporter", [], "data")
      end
      def test_import_products
        persistence = flexmock("persistence")
        flexstub(ProductImporter).should_receive(:new).times(1).and_return {
          importer = flexmock('importer')
          importer.should_receive(:import).times(1).and_return { |io|
            assert_equal('data', io)
          }
          importer
        }
        Updater.import("ProductImporter", [], "data")
      end
      def test_import_quotas
         persistence = flexmock("persistence")
        flexstub(QuotaImporter).should_receive(:new).times(1).and_return {
          importer = flexmock('importer')
          importer.should_receive(:import).times(1).and_return { |io|
            assert_equal('data', io)
          }
          importer
        }
        Updater.import("QuotaImporter", [], "data")
      end
      def test_run__customers
        flexstub(Updater).should_receive(:import).times(1).and_return {
          |importer, args, data|
          assert_equal("CustomerImporter", importer)
          assert_equal([], args)
          assert_equal("mockdata", data)
        }
        flexstub(PollingManager).should_receive(:new).and_return {
          mgr = flexmock("PollingManager")
          mgr.should_receive(:poll_sources).and_return { |block|
            block.call("KUNDEN.CSV", "mockdata")
          }
          mgr
        }
        Updater.run
      end
      def test_run__products
        flexstub(Updater).should_receive(:import).times(1).and_return {
          |importer, args, data|
          assert_equal("ProductImporter", importer)
          assert_equal([:de], args)
          assert_equal("mockdata", data)
        }
        flexstub(PollingManager).should_receive(:new).and_return {
          mgr = flexmock("PollingManager")
          mgr.should_receive(:poll_sources).and_return { |block|
            block.call("ARTIKEL.CSV", "mockdata")
          }
          mgr
        }
        Updater.run
      end
      def test_run__products_fr
        flexstub(Updater).should_receive(:import).times(1).and_return {
          |importer, args, data|
          assert_equal("ProductImporter", importer)
          assert_equal([:fr], args)
          assert_equal("mockdata", data)
        }
        flexstub(PollingManager).should_receive(:new).and_return {
          mgr = flexmock("PollingManager")
          mgr.should_receive(:poll_sources).and_return { |block|
            block.call("ARTIKEL_FR.CSV", "mockdata")
          }
          mgr
        }
        Updater.run
      end
      def test_run__quotas
        flexstub(Updater).should_receive(:import).times(1).and_return {
          |importer, args, data|
          assert_equal("QuotaImporter", importer)
          assert_equal([], args)
          assert_equal("mockdata", data)
        }
        flexstub(PollingManager).should_receive(:new).and_return {
          mgr = flexmock("PollingManager")
          mgr.should_receive(:poll_sources).and_return { |block|
            block.call("ABSCHLUSS.CSV", "mockdata")
          }
          mgr
        }
        Updater.run
      end
    end
  end
end
