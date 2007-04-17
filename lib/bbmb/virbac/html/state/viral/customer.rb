#!/usr/bin/env ruby
# Html::State::Viral::Customer -- bbmb -- 11.04.2007 -- hwyss@ywesee.com

require 'bbmb/html/state/viral/customer'
require 'bbmb/html/state/catalogue'
require 'bbmb/html/state/quotas'
require 'bbmb/html/state/promotions'

module BBMB
  module Html
    module State
      module Viral
module Customer 
  def catalogue
    State::Catalogue.new(@session, BBMB.persistence.all(Model::Product))
  end
  def promotions
    products = BBMB.persistence.all(Model::Product).select { |product|
      (product.promotion && product.promotion.current?) \
        || (product.sale && product.sale.current?)
    }
    State::Promotions.new(@session, products)
  end
  def quotas
    State::Quotas.new(@session, _customer.quotas)
  end
  unless(instance_methods.include?("__extension_zone_navigation__"))
    alias :__extension_zone_navigation__ :zone_navigation
  end
  def zone_navigation
    __extension_zone_navigation__.push(:catalogue, :quotas, :promotions)
  end
end
      end
    end
  end
end
