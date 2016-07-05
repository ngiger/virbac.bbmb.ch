#!/usr/bin/env ruby
# Html::View::Calculator -- bbmb -- 18.04.2007 -- hwyss@ywesee.com

require 'bbmb/html/view/multilingual'
require 'bbmb/html/view/template'
require 'bbmb/html/view/list_prices'
require 'htmlgrid/divform'
require 'htmlgrid/dojotoolkit'
require 'htmlgrid/inputcheckbox'

module BBMB
  module Html
    module View
class CalculatorList < HtmlGrid::List
  include Multilingual
  include Vat
  BACKGROUND_ROW = 'bg'
  BACKGROUND_SUFFIX = ''
  COMPONENTS = {
    [0,0] => :description,
    [1,0] => :price_base,
    [2,0] => :price_public,
  }
  CSS_MAP = {
    [1,0] => 'right',
    [2,0] => 'right total',
  }
  CSS_HEAD_MAP = {
    [1,0] => 'right',
    [2,0] => 'right',
  }
  LEGACY_INTERFACE = false
  SORT_DEFAULT = :description
  SORT_HEADER = false
  def init
    @factor = (@session.cookie_set_or_get(:factor) || 1.5).to_f
    if(@vat = @session.cookie_set_or_get(:show_vat))
      components.update({
        [2,0] => :exclusive,
        [3,0] => :vat,
        [4,0] => :vat_value,
        [5,0] => :price_public,
      })
      css_map.update({
        [2,0]   => 'right',
        [3,0,2] => 'right',
        [5,0]   => 'right total',
      })
      css_head_map.update({
        [3,0] => 'right', 
        [4,0] => 'right',
        [5,0] => 'right',
      })
    end
    super
  end
  def exclusive(model)
    model.price * @factor
  end
  def price_public(model)
    if(@vat)
      exclusive(model) * (model.vat + 100) / 100.0
    else
      exclusive(model)
    end
  end
  def vat_value(model)
    exclusive(model) * model.vat / 100.0
  end
end
class CalculatorComposite < HtmlGrid::DivForm
  COMPONENTS = {
    [0,0] => 'calculator_explain', 
    [0,1] => :categories,
    [0,2] => :factor,
    [1,2] => :submit,
    [2,2] => :show_vat,
    [3,2] => 'show_vat',
    [0,3] => :products,
  }
  CSS_ID_MAP = { 
    0 => 'title',
    3 => 'products',
  }
  CSS_MAP = { 
    1 => 'tab',
    2 => 'toggler',
  }
  EVENT = 'calculate'
  def categories(model)
    cur = current
    model.categories.collect { |cat|
      link = HtmlGrid::Link.new(cat, model, @session, self)
      unless(cat == cur)
        link.href = @lookandfeel._event_url(:calculator, :category => cat)
      end
      link.value = cat
      link
    }
  end
  def current
    @session.state.current
  end

  def createCalcScript(css_id)
    %(require(['dojo']);
    document.getElementsByName('#{EVENT}')[0].click();
    )
  end
  def factor(model)
    input = HtmlGrid::InputText.new(:factor, model, @session, self)
    input.value = @session.cookie_set_or_get(:factor) || '1.5'
    input.css_class = 'tiny'
    input.css_id = input.name
    input.set_attribute('onChange', createCalcScript(input.css_id))
    [HtmlGrid::SimpleLabel.new(:factor, input, @session, self), input]
  end
  def products(model)
    CalculatorList.new(model.send(current), @session, self)
  end
  def show_vat(model)
    input = HtmlGrid::InputCheckbox.new(:show_vat, model, @session, self)
    input.css_id = input.name
    input.set_attribute('onClick', createCalcScript(input.css_id))
    input.set_attribute('checked', @session.cookie_set_or_get(:show_vat))
    input
  end
  def submit(model)
    self.onsubmit = %(this.setAttribute('method', 'POST');
    this.setAttribute('action',  window.location.href);
    return true;)
    super
  end
end
class Calculator < Template
  include HtmlGrid::DojoToolkit::DojoTemplate
  CONTENT = CalculatorComposite
  DOJO_DEBUG = BBMB.config.debug
  JAVASCRIPTS = []
end
    end
  end
end
