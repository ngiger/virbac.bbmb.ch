#!/usr/bin/env ruby
# Html::View::Result -- bbmb -- 11.04.2007 -- hwyss@ywesee.com

require 'bbmb/html/view/catalogue'
require 'bbmb/html/view/result'
require 'bbmb/html/view/promotions'
require 'htmlgrid/datevalue'
require 'htmlgrid/dojotoolkit'

module BBMB
  module Html
    module View
class Products
  include CatalogueMethods
  include PromotionMethods
  COMPONENTS = {
    [0,0]	=>	:quantity,
    [1,0]	=>	:promotions,
    [2,0]	=>	:description,
    [3,0]	=>	:catalogue1,
    [3,1]	=>	:catalogue2,
    [4,0]	=>	:backorder,
    [5,0]	=>	:expiry_date,
    [6,0] =>  :price,
    [7,0] =>  :price_levels,
    [8,0] =>  :price2,
    [9,0] =>  :price3,
    [7,1] =>  :price4,
    [8,1] =>  :price5,
    [9,1] =>  :price6,
  }
  CSS_HEAD_MAP = {
    [5,0] => 'right',
    [6,0] => 'right',
    [7,0] => 'right',
  }
  CSS_MAP = { 
    [0,0]     => 'tiny', 
    [2,0]     => 'description',
    [5,0,5,2] => 'right'
  }
  SYMBOL_MAP = {
    :expiry_date => HtmlGrid::DateValue, 
  }
end
class Result
  include HtmlGrid::DojoToolkit::DojoTemplate
  DOJO_REQUIRE = [ 'dojo.widget.*', 'dojo.widget.Tooltip' ]
end
    end
  end
end
