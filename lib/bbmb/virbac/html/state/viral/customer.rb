#!/usr/bin/env ruby
# Html::State::Viral::Customer -- bbmb -- 11.04.2007 -- hwyss@ywesee.com

require 'bbmb/html/state/viral/customer'
require 'bbmb/html/state/calculator'
require 'bbmb/html/state/catalogue'
require 'bbmb/html/state/change_password'
require 'bbmb/html/state/quotas'
require 'bbmb/html/state/promotions'
require 'ostruct'

module BBMB
  module Html
    module State
      module Viral
module Customer 
  def calculator
    products = BBMB.persistence.all(Model::Product).select { |product|
      product.price
    }
    State::Calculator.new(@session, products)
  end
  def catalogue
    State::Catalogue.new(@session, BBMB.persistence.all(Model::Product))
  end
  def change_pass
    ChangePassword.new(@session, _customer)
  end
  def promotions
    State::Promotions.new(@session, BBMB.persistence.all(Model::Product))
  end
  def quotas
    State::Quotas.new(@session, _customer.quotas)
  end
  unless(instance_methods.include?("__extension_zone_navigation__"))
    alias :__extension_zone_navigation__ :zone_navigation
  end
  def zone_navigation
    __extension_zone_navigation__.push(:catalogue, :quotas, :promotions,
                                       :calculator, :change_pass)
  end
end
      end
    end
  end
end
