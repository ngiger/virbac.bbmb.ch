#!/usr/bin/env ruby
# Util::PasswordImporter -- virbac.bbmb.ch -- 16.05.2007 -- hwyss@ywesee.com

require 'bbmb/model/customer'
require 'bbmb/config'
require 'digest/md5'
require 'spreadsheet'

module BBMB
  module Util
    class PasswordImporter 
      def initialize(rootname, password)
        @session = BBMB.auth.login(rootname, password, BBMB.config.auth_domain)
      end
      def import(io, persistence=BBMB.persistence)
        count = 0
        workbook = Spreadsheet.open(io)
        workbook.worksheet(0).each(1) { |row| 
          import_record(row) && count += 1
        }
        postprocess(persistence)
        count
      end
      def import_record(row)
        id = row.at(11).to_i
        password = string(row, 3)
        email = string(row, 10)
        if(!password.empty? && !email.empty? \
           && (customer = Model::Customer.find_by_customer_id(id)) \
           && (email == customer.email))
          hash = Digest::MD5.hexdigest(password)
          @session.grant(email, 'login', 
                         BBMB.config.auth_domain + '.Customer')
          @session.set_password(email, hash)
        end
      end
      def postprocess(persistence)
        BBMB.auth.logout(@session)
      end
      def string(row, idx)
        if(cell = row.at(idx))
          cell.to_s('utf8')
        end.to_s
      end
    end
  end
end
