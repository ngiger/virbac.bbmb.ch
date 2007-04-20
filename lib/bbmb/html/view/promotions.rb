#!/usr/bin/env ruby
# Html::View::Promotions -- bbmb -- 11.04.2007 -- hwyss@ywesee.com

require 'bbmb/html/view/template'
require 'htmlgrid/datevalue'

module BBMB
  module Html
    module View
module PromotionMethods
  def current_promo(model, key)
    if((promo = model.send(key)) && promo.current?)
      promo
    end
  end
  def end_date(model, key)
    if(promo = current_promo(model, key))
      HtmlGrid::DateValue.new(:end_date, promo, @session, self)
    end
  end
  def lines(model, key)
    if(promo = current_promo(model, key))
      lines = promo.lines.collect { |line|
        num = 1
        if(match = /(\d+)\s*x\s*\d/.match(line.to_s))
          num = match[1].to_i
        end
        quantity = 'quantity[%s]' % model.article_number
        link = HtmlGrid::Link.new(:promotion, model, @session, self)
        link.value = line
        link.href = @lookandfeel._event_url(:order_product, 
                                            quantity => num)
        link.css_class = 'block'
        link
      }
    end
  end
  def promotions(model)
    [_promotion(model, :promotion), _promotion(model, :sale)].compact
  end
  def _promotion(model, key)
    if(promo = current_promo(model, key))
      link = HtmlGrid::Link.new(key, model, @session, self)
      link.css_class = key.to_s
      link.css_id = sprintf "%s-%s", key,  model.article_number
      lines = [@lookandfeel.lookup('%s_explain' % key)]
      link.dojo_title = lines + lines(model, key)
      link.href = @lookandfeel._event_url(:promotions)
      link
    end
  end
end
class PromotionsComposite < HtmlGrid::List
  include PromotionMethods
  BACKGROUND_ROW = 'bg'
  BACKGROUND_SUFFIX = ''
  COMPONENTS = {
    [0,0] => :description,
    [1,0] => :promotion_lines,
    [2,0] => :promotion_date,
    [3,0] => :sale_lines,
    [4,0] => :sale_date,
  }
  CSS_CLASS = 'list'
  CSS_HEAD_MAP = {
    [2,0] => 'right',
    [4,0] => 'right',
  }
  CSS_MAP = {
    [0,0] => 'description',
    [2,0] => 'right',
    [4,0] => 'right',
  }
  SORT_DEFAULT = :description
  SORT_HEADER = false
  def promotion_date(model)
    end_date(model, :promotion)
  end
  def promotion_lines(model)
    lines(model, :promotion)
  end
  def sale_date(model)
    end_date(model, :sale)
  end
  def sale_lines(model)
    lines(model, :sale)
  end
end
class Promotions < Template
  CONTENT = PromotionsComposite
end
    end
  end
end
