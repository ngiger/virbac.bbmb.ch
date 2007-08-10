#!/usr/bin/env ruby
# Html::State::Calculator -- bbmb -- 18.04.2007 -- hwyss@ywesee.com

require 'bbmb/html/state/global'
require 'bbmb/html/util/multilingual'
require 'bbmb/html/view/calculator'
require 'ostruct'

module BBMB
  module Html
    module State
class AjaxCalculator < Global
  VIEW = Html::View::CalculatorList
  VOLATILE = true
end
class Calculator < Global
  include Util::Multilingual
  DIRECT_EVENT = :calculator
  VIEW = Html::View::Calculator
  def init
    super
    data = {}
    @model.each { |product|
      if(cat = _(product.catalogue1))
        (data[cat] ||= []).push(product)
      end
    }
    @model = OpenStruct.new(data)
    @model.categories = data.keys.sort
  end
  def ajax
    _calculate
    AjaxCalculator.new(@session, @model.send(current))
  end
  def _calculate
    unless(@session.user_input(:show_vat))
      @session.set_cookie_input(:show_vat, false)
    end
  end
  def calculate
    _calculate
    self
  end
  def current
    (@session.persistent_user_input(:category) \
     || @model.categories).first
  end
end
    end
  end
end
