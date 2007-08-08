#!/usr/bin/env ruby
# Html::State::Promotions -- bbmb -- 11.04.2007 -- hwyss@ywesee.com

require 'bbmb/html/state/global'
require 'bbmb/html/view/promotions'

module BBMB
  module Html
    module State
class Promotions < Global
  DIRECT_EVENT = :promotions
  VIEW = Html::View::Promotions
  class Facade
    attr_reader :promotions, :sales
    def initialize(visible)
      @promotions = visible.select { |product|
        product.promotion && product.promotion.current?
      }
      @sales = visible.select { |product|
        product.sale && product.sale.current?
      }
    end
    def sort_by(*args, &block)
      @promotions = @promotions.sort_by(*args, &block)
      @sales = @sales.sort_by(*args, &block)
      self
    end
  end
  def init
    customer = _customer
    @model = Facade.new @model.reject { |product|
      customer.quota(product.article_number) 
    }
  end
end
    end
  end
end
