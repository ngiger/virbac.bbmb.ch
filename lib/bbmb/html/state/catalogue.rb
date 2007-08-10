#!/usr/bin/env ruby
# Html::State::Catalogue -- bbmb -- 16.04.2007 -- hwyss@ywesee.com

require 'bbmb/html/state/global'
require 'bbmb/html/util/multilingual'
require 'bbmb/html/view/catalogue'

module BBMB
  module Html
    module State
class Catalogue < Global
  DIRECT_EVENT = :catalogue
  VIEW = Html::View::Catalogue
  class Catalogue < Array
    include Util::Multilingual
    def initialize(products, session)
      @session = session
      level1 = {}
      products.delete_if { |product|
        product.catalogue1.nil? 
      }.each { |product|
        level2 = (level1[_ product.catalogue1] ||= {})
        level3 = (level2[_ product.catalogue2] ||= [])
        level3.push(product)
      }
      concat level1.sort.collect { |key2, level2|
        [key2, level2.sort.collect { |key3, level3|
          [key3, level3.sort_by { |product| _(product.description) }]
        }]
      }
    end
  end
  def init
    super
    @model = Catalogue.new(@model, @session)
  end
end
    end
  end
end
