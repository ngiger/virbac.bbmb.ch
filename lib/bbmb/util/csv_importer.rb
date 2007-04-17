#!/usr/bin/env ruby
# Util::CsvImporter -- de.oddb.org -- 10.04.2007 -- hwyss@ywesee.com

require 'bbmb'
require 'bbmb/model/customer'
require 'bbmb/model/quota'
require 'bbmb/model/product'
require 'bbmb/model/promotion'
require 'date'
require 'encoding/character/utf-8'
require 'iconv'
require 'csv'

module BBMB
  module Util
    class CsvImporter 
      def initialize
        @skip = 1
      end
      def import(io, persistence=BBMB.persistence)
        count = 0
        CSV::IOReader.new(io, ',').each_with_index { |record, idx|
          count += 1
          next if(count <= @skip)
          if(objects = import_record(record))
            persistence.save(*objects)
          end
        }
        postprocess(persistence)
        count
      end
      def date(str)
        Date.parse(str.tr('.', '-'))
      rescue
      end
      def postprocess(persistence)
      end
      def string(str)
        str = u(Iconv.new('utf-8', 'latin1').iconv(str.to_s)).strip
        str.gsub(/\s+/, ' ') unless str.empty? 
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
      def import_record(record)
        customer_id = string(record[0])
        active = string(record[1]) == 'A'
        customer = Model::Customer.find_by_customer_id(customer_id)
        if(customer.nil? && active)
          customer = Model::Customer.new(customer_id)
        end
        if(customer)
          CUSTOMER_MAP.each { |idx, name|
            unless customer.protects? name
              value = string(record[idx])
              case name
              when :status
                customer.status = value == 'A' ? :active : :inactive
              when :language
                customer.language = LANGUAGES.fetch(value, 'de')
              else
                customer.send("#{name}=", value)
              end
            end
          }
        end
        customer
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
        art_id = string(record[3])
        if((custmr = Model::Customer.find_by_customer_id(customer_id)) \
           && (product = Model::Product.find_by_article_number(art_id)))
          quota = custmr.quota(art_id)
          if(quota.nil?)
            quota = custmr.add_quota(Model::Quota.new(product))
          end
          QUOTA_MAP.each { |idx, name|
            value = string(record[idx])
            case name
            when :start_date, :end_date
              value = date(value)
            end
            quota.send("#{name}=", value)
          }
          (@active_quotas[customer_id] ||= []).push(quota)
          [quota, custmr.quotas]
        end
      end
      def postprocess(persistence)
        persistence.all(Model::Customer).each { |customer|
          active = @active_quotas[customer.customer_id] || []
          persistence.delete(customer.quotas - active)
        }
      end
    end
    class ProductImporter < CsvImporter
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
        13  =>  :mwst,
        14  =>  :ean13,
        15  =>  :catalogue1,
        16  =>  :catalogue2,
        17  =>  :catalogue3,
        18  =>  :expiry_date,
      }
      def import_record(record)
        article_number = string(record[0])
        product = Model::Product.find_by_article_number(article_number) \
          || Model::Product.new(article_number)
        PRODUCT_MAP.each { |idx, name|
          value = string(record[idx])
          case name
          when :expiry_date
            value = date(value)
          when :status
            value = (value == 'A') ? :active : :inactive
          end
          product.send("#{name}=", value)
        }
        product.promotion = import_promotion(record, 19)
        product.sale = import_promotion(record, 25)
        product
      end
      def import_promotion(record, offset)
        lines = []
        4.times { |idx|
          lines.push(string(record[offset + idx]))
        }
        lines.compact!
        unless(lines.empty?)
          promotion = Model::Promotion.new
          promotion.lines.replace(lines)
          promotion.start_date = date(record[offset + 4])
          promotion.end_date = date(record[offset + 5])
          promotion
        end
      end
    end
  end
end
