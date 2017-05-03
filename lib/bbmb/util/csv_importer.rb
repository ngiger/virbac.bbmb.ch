#!/usr/bin/env ruby
# encoding: ASCII-8BIT
# Util::CsvImporter -- de.oddb.org -- 10.04.2007 -- hwyss@ywesee.com

require 'bbmb'
require 'bbmb/model/customer'
require 'bbmb/model/quota'
require 'bbmb/model/product'
require 'bbmb/model/promotion'
require 'bbmb/util/mail'
require 'date'
require 'csv'
require 'drb'
module BBMB
  module Model
    class Customer
      puts "TODO: Remove monkey patching bbmb because of missing customer 3219 as of 2017.04.25"
      def quota(article_id)
        quota_copy = @quotas.clone
        @quotas.each do |quota|
          next if quota.is_a?(BBMB::Model::Quota)
          puts "Customer.quota: called delete_persistable for #{quota.odba_id}"
          ODBA.storage.delete_persistable(quota.odba_id)
          ODBA.cache.invalidate(quota.odba_id)
          quota_copy.delete_if{ |x| x.odba_id == quota.odba_id }
        end
        @quotas = quota_copy.compact
        @quotas.find { |quota| puts "Unexpected class for article_id #{article_id} odba_id #{odba_id} #{quota.class} in #{self}" unless quota.is_a?(BBMB::Model::Quota) ; quota.is_a?(BBMB::Model::Quota) && quota.article_number == article_id }
      end
    end
  end
end unless defined?(MiniTest)

module BBMB
  module Util
    class CsvImporter
      include DRb::DRbUndumped
      @@success = true
      def initialize
        @skip = 1
        at_exit do
          if @@success
            FileUtils.rm_f(@io_path, :verbose => true) if File.exist?(@io_path)
          else
            puts "Skipping rm #{@io_path} as succes is #{@@success}"
          end
        end
      end
      def import(io, persistence=BBMB.persistence)
        count = 0
        if io.is_a?(StringIO)
          puts  "#{File.basename(__FILE__)}:  importing string"
          @io_path = 'String'
          csv = CSV.new(io)
        else
          @io_path = io.to_path
          encoding = File.read(@io_path).encoding
          if encoding.to_s.eql?('UTF-8')
            csv = CSV.new(File.read(@io_path))
          else
            csv = CSV.new(File.read(@io_path, :encoding => encoding).encode('UTF-8'))
          end
          puts  "#{File.basename(__FILE__)}: #{encoding} importing #{@io_path} #{csv.count} lines"
        end
        csv.rewind
        csv.each_with_index do |record, idx|
          count += 1
          next if(count <= @skip)
          STDOUT.write "." if(count % 100 == 0)
          puts " #{count}\n" if(count % 1000 == 0)
          next unless record.size >= CustomerImporter::CUSTOMER_MAP.size
          puts "import_record #{count}: #{record}. size #{record.size} #{record.class}" if $VERBOSE
          if(objects = import_record(record))
            persistence.save(*objects)
          end
        end
        postprocess(persistence)
        puts  "#{File.basename(__FILE__)}: finished. #{@io_path}. count is #{count}"
        count
      rescue => error
        puts "Rescue #{error} in import"
        @@success = false
      end
      def date(str)
        Date.parse(str.tr('.', '-'))
      rescue => error
      end
      def postprocess(persistence)
        puts "CsvImporter postprocess"
      end
      def string(str)
        str.encode('UTF-8', {invalid: :replace, undef: :replace, replace: ''}) if str
        str.gsub(/\s+/, ' ').sub(/\s+$/, '') if str && !str.empty?
      end
    end
    class CustomerImporter < CsvImporter
      CUSTOMER_MAP = {
        1   =>  :status,
        2   =>  :organisation,
        3   =>  :address1,
        4   =>  :plz,
        5   =>  :city,
        6   =>  :address2,
        7   =>  :email,
        8   =>  :language,
        9   =>  :canton,
      }
      LANGUAGES = {
        'd' => 'de',
        'f' => 'fr',
      }
      def initialize
        super
        @duplicates = []
      end
      def import_record(record)
        customer_id = string(record[0])
        if customer_id.to_i == 3219
          puts "Skipping customer 3219" # Skipping bachmann
          return
        end
        return unless(/^\d+$/.match(customer_id))
        active = string(record[1]) == 'A'
        customer   = Model::Customer.find_by_customer_id(customer_id)
        if customer.nil? && defined?(Model::Customer.odba_extent)
          if customer2 = Model::Customer.odba_extent.find_all { |x| (x.customer_id.to_i == customer_id.to_i || /#{record[7].gsub('*','')}/.match(x.email)) }.first
            customer2.odba_delete
            ODBA.storage.delete_persistable(customer2.odba_id)
            ODBA.cache.invalidate(customer2.odba_id)
            puts "CustomerImporter: 1: called delete_persistable for #{customer2.odba_id}. Now find_by_customer_id returns #{Model::Customer.find_by_customer_id(customer_id).inspect}"
          end
        end
        if customer && !customer.is_a?(Model::Customer)
          ODBA.storage.delete_persistable(customer.odba_id)
          ODBA.cache.invalidate(customer.odba_id)
          puts "CustomerImporter: 2: called delete_persistable for #{customer.odba_id}. Now find_by_customer_id returns #{Model::Customer.find_by_customer_id(customer_id).inspect}"
          customer = nil
        end
        if (customer.nil? && active)
          customer = Model::Customer.new(customer_id)
          puts "Created new customer_id #{customer_id} which is a #{customer.class} with odba_id #{customer.odba_id}"
        end
        if(customer)
          has_changes = false
          CUSTOMER_MAP.each do |idx, name|
            unless customer.protects? name
              value = string(record[idx])
              case name
              when :email
                  # puts "ignoring #{name} from '#{customer.send("#{name}")}' with '#{value}'"
              when :status
                saved_status = customer.status
                customer.status = value == 'A' ? :active : :inactive
                has_changes = true unless customer.status.eql?(saved_status)
              when :language
                saved_language = customer.language
                customer.language = LANGUAGES.fetch(value, 'de')
                has_changes = true unless customer.language.eql?(saved_language)
              else
                orig_value = eval("customer.#{name}")
                begin
                  puts "send #{name}= #{value}. Was #{customer.email}" if name.eql?(:email) && $VERBOSE
                  customer.send("#{name}=", value)
                rescue => error
                  puts "#{error}: Unable to change #{name} from '#{customer.send("#{name}")}' to '#{value}' for #{record}."
                end
                value = eval("customer.#{name}")
                has_changes = true unless value.to_s.eql?(orig_value.to_s)
              end
            end
          end
          customer.odba_store if has_changes
        end
        customer
      rescue => err
        if /DuplicateNameError|Duplicate name/.match(err.to_s)
          @duplicates.push(err)
        else
          puts err.backtrace.join("\n")
          @@success = false
          raise(err.to_s)
        end
        nil
      end
      def postprocess(persistence)
        puts "CustomerImporter postprocess"
        super
        unless(@duplicates.empty?)
          err = @duplicates.shift
          @duplicates.each { |other| err.message << "\n" << other.message }
          Util::Mail.notify_error(err)
          puts "Util::Mail.notify_err: #{@duplicates.size} @duplicates done"
        end
      end
    end
    class ProductImporter < CsvImporter
      def initialize(language)
        super()
        @language = language
        @active_products = {}
      end
      VAT = {
        '1' => 2.5,
        '2' => 8.0,
      }
      PRODUCT_MAP = {
        1   =>  :status,
        2   =>  :description,
       #3   =>  :l0_qty,   # Sollte immer 1 sein
        4   =>  :price,    # Preis
        5   =>  :l1_qty,   # Staffelpreise, Stück 1
        6   =>  :l1_price, # Staffelpreise, Preis 1
        7   =>  :l2_qty  , # Staffelpreise, Stück 2
        8   =>  :l2_price, # Staffelpreise, Preis 2
        9   =>  :l3_qty  , # Staffelpreise, Stück 3
        10  =>  :l3_price, # Staffelpreise, Preis 3
        11  =>  :l4_qty  , # Staffelpreise, Stück 4
        12  =>  :l4_price, # Staffelpreise, Preis 4
        13  =>  :vat,
        14  =>  :ean13,
        15  =>  :catalogue1,
        16  =>  :catalogue2,
        17  =>  :catalogue3,
        18  =>  :expiry_date,
        31  =>  :backorder,
        32  =>  :backorder_date,
      }
      PROMOTION_MAP = {
        0   =>  :l1_qty,
        1   =>  :l1_free,
        2   =>  :l1_price,
        3   =>  :l1_discount,
        4   =>  :l2_qty,
        5   =>  :l2_free,
        6   =>  :l2_price,
        7   =>  :l2_discount,
        8   =>  :l3_qty,
        9   =>  :l3_free,
        10  =>  :l3_price,
        11  =>  :l3_discount,
        12  =>  :l4_qty,
        13  =>  :l4_free,
        14  =>  :l4_price,
        15  =>  :l4_discount,
      }
      def import_record(record)
        article_number = string(record[0])
        return unless(/^\d+$/.match(article_number))
        @active_products.store article_number, true
        product = Model::Product.find_by_article_number(article_number) \
          || Model::Product.new(article_number)
        if product && !product.is_a?(Model::Product)
          ODBA.storage.delete_persistable(product.odba_id)
          ODBA.cache.invalidate(product.odba_id)
          puts "ProductImporter: called delete_persistable for #{product.odba_id}. Now find_by_article_number returns #{Model::Product.find_by_article_number(article_number).inspect}"
          product = Model::Product.new(article_number)
        end
        PRODUCT_MAP.each do |idx, name|
          value = string(record[idx])
          writer = "#{name}="
          case name
          when *product.multilinguals
            product.send(name).send("#@language=", value)
          when :expiry_date, :backorder_date
            product.send(writer, date(value))
          when :vat
            product.send(writer, VAT[value])
          when :status
            product.send(writer, (value == 'A') ? :active : :inactive)
          else
            begin
              product.send(writer, value)
            rescue => error
              puts "#{error}: Unable to change #{name} from '#{product.send("#{name}")}' to '#{value}' for #{record}."
            end
          end
        end
        product.promotion = import_promotion(product.promotion, record, 19, 33)
        product.sale = import_promotion(product.sale, record, 25, 49)
        product.odba_store
        product
      end
      def import_promotion(previous, record, offset, offset2)
        lines = []
        4.times { |idx|
          lines.push(string(record[offset + idx]))
        }
        lines.compact!
        if(@language == :de)
          unless(lines.empty?)
            promotion = Model::Promotion.new
            promotion.lines.de = lines
            promotion.start_date = date(record[offset + 4])
            promotion.end_date = date(record[offset + 5])
            PROMOTION_MAP.sort.each { |idx, name|
              value = string(record[idx + offset2]).to_f
              if(value > 0)
                promotion.send("#{name}=", value)
              end
            }
            promotion
          end
        elsif(previous)
          previous.lines.send("#@language=", lines)
          previous
        end
      end
      def postprocess(persistence)
        puts "ProductImporter postprocess"
        return if(@active_products.empty?)
        deletables = []
        persistence.all(BBMB::Model::Product) { |product|
          unless(@active_products.include?(product.article_number))
            deletables.push product
          end
        }
        persistence.all(BBMB::Model::Customer) { |customer|
          order = customer.current_order
          quotas = customer.quotas
          deleted_quotas = []
          deletables.each { |product|
            order.add(0, product)
            if(quota = customer.quota(product.article_number))
              quotas.delete(quota)
              deleted_quotas.push(quota)
            end
          }
          unless(deleted_quotas.empty?)
            persistence.save(quotas)
            persistence.delete(*deleted_quotas)
          end
        }
        persistence.delete(*deletables) unless(deletables.empty?)
      end
    end
    class QuotaImporter < CsvImporter
      QUOTA_MAP = {
        5  => :start_date,
        6  => :end_date,
        7  => :target,
        8  => :actual,
        9  => :difference,
        10 => :price,
      }
      def initialize
        super
        @skip = 2
        @active_quotas = {}
      end
      def import_record(record)
        customer_id = string(record[0])
        return unless(/^\d+$/.match(customer_id))
        art_id = string(record[3])
        if (art_id  \
           && (customer = Model::Customer.find_by_customer_id(customer_id)) \
           && (product = Model::Product.find_by_article_number(art_id)))
          return unless customer && product
          if customer && !customer.is_a?(Model::Customer)
            ODBA.storage.delete_persistable(customer.odba_id)
            ODBA.cache.invalidate(customer.odba_id)
            puts "QuotaImporter: called delete_persistable for #{customer.odba_id}. Now find_by_article_number returns #{Model::Customer.find_by_customer_id(customer_id).inspect}"
            customer = Model::Customer.new(customer_id)
          end
          if product && !product.is_a?(Model::Product)
            ODBA.storage.delete_persistable(product.odba_id)
            ODBA.cache.invalidate(product.odba_id)
            puts "QuotaImporter: called delete_persistable for #{product.odba_id}. Now find_by_article_number returns #{Model::Product.find_by_article_number(article_number).inspect}"
            product = Model::Product.new(article_number)
          end
          puts "Importing Quota for art_id #{art_id}" if $VERBOSE
          quota = customer.quota(art_id)
          if(quota.nil?)
            quota = customer.add_quota(Model::Quota.new(product))
          end
          has_changes = false
          QUOTA_MAP.each { |idx, name|
            value = string(record[idx])
            orig_value = eval("quota.#{name}")
            case name
            when :start_date, :end_date
              value = date(value)
            end
            quota.send("#{name}=", value)
            value = eval("quota.#{name}")
            has_changes = true unless value.to_s.eql?(orig_value.to_s)
          }
          (@active_quotas[customer_id] ||= []).push(quota)
          if has_changes
            @active_quotas[customer_id].odba_store if has_changes
            quota.odba_store
          end

          [quota, customer.quotas]
        end
      end
      def postprocess(persistence)
        puts "QuotaImporter postprocess"
        persistence.all(Model::Customer).each { |customer|
          active = @active_quotas[customer.customer_id] || []
          persistence.delete *(customer.quotas.compact - active).compact
        }
      end
    end
  end
end
