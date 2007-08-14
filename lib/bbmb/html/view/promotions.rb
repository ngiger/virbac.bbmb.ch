#!/usr/bin/env ruby
# Html::View::Promotions -- bbmb -- 11.04.2007 -- hwyss@ywesee.com

require 'bbmb/html/view/multilingual'
require 'bbmb/html/view/template'
require 'htmlgrid/datevalue'

module BBMB
  module Html
    module View
module PromotionMethods
  include Util::Multilingual
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
    if((promo = current_promo(model, key)) \
       && (lines = _(promo.lines)))
      output = []
      lines.each_with_index { |line, idx|
        num = 1
        if(qty = promo.qty_level(idx + 1))
          num = qty
        elsif(match = /(\d+)\s*x\s*\d/.match(line.to_s))
          num = match[1].to_i
        end
        quantity = 'quantity[%s]' % model.article_number
        link = HtmlGrid::Link.new(:promotion, model, @session, self)
        link.value = line
        link.href = @lookandfeel._event_url(:order_product, 
                                            quantity => num)
        link.css_class = 'block'
        output.push link
      }
      output
    end
  end
  def promotions(model)
    unless(@model.quota model.article_number)
      [_promotion(model, :promotion), _promotion(model, :sale)].compact
    end
  end
  def _promotion(model, key)
    if(promo = current_promo(model, key))
      link = HtmlGrid::Link.new(key, model, @session, self)
      link.css_class = key.to_s
      link.css_id = sprintf "%s-%s", key,  model.article_number
      lines = [@lookandfeel.lookup('%s_explain' % key)]
      link.dojo_title = lines + (lines(model, key) || [])
      link.href = @lookandfeel._event_url(:promotions)
      link
    end
  end
  def quantity(model)
    qty = model.quantity
    if(freebies = model.freebies)
      qty = sprintf("%s + %s", qty, freebies)
    end
    qty
  end
end
class PromotionsComposite < HtmlGrid::List
  include Multilingual
  include PromotionMethods
  BACKGROUND_ROW = 'bg'
  BACKGROUND_SUFFIX = ''
  COMPONENTS = {
    [0,0] => :description,
    [1,0] => :lines,
    [2,0] => :date,
  }
  CSS_CLASS = 'list'
  CSS_HEAD_MAP = {
    [2,0] => 'right',
    [4,0] => 'right',
  }
  CSS_MAP = {
    [0,0] => 'description',
    [2,0] => 'right',
  }
  SORT_DEFAULT = :description
  SORT_HEADER = false
  def compose(model=@model, offset=[0,0])
    offset = compose_header(offset) 
    offset = compose_part(:sale, offset)
    offset = compose_part(:promotion, offset)
  end
  def compose_part(key, offset)
    @promo_key = key
    model = @model.send("%ss" % key)
    offset = compose_subheader(model, offset)
    compose_list(model, offset)
  end
  def compose_subheader(model, offset)
    @grid.add(@lookandfeel.lookup("subheader_#{@promo_key}", model.size), *offset)
    @grid.set_row_attributes({'class' => 'divider'}, offset.at(1))
    resolve_offset(offset, [0,1])
  end
  def date(model)
    end_date(model, @promo_key)
  end
  def lines(model)
    super(model, @promo_key)
  end
end
class Promotions < Template
  CONTENT = PromotionsComposite
end
    end
  end
end
