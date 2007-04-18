#!/usr/bin/env ruby
# Html::View::Order -- bbmb -- 17.04.2007 -- hwyss@ywesee.com

require 'bbmb/html/view/catalogue'
require 'bbmb/html/view/order'

module BBMB
  module Html
    module View
class Positions
  include CatalogueMethods
  COMPONENTS = {
    [0,0]  =>  :quantity,
    [1,0]  =>  :description,
    [2,0]	 =>	 :catalogue1,
    [2,1]	 =>	 :catalogue2,
    [3,0]  =>  :price_base,
    [4,0]  =>  :price_levels,
    [5,0]  =>  :price2,
    [4,1]  =>  :price3,
    [5,1]  =>  :price4,
    [6,0]  =>  :total,
    [7,0]  =>  :vat,
  }
  CSS_MAP = {
    [0,0]     => 'tiny right',
    [1,0]     => 'description',
    [3,0,3,2] => 'right',
    [6,0]     => 'total',
    [7,0]     => 'right',
  }
  CSS_HEAD_MAP = {
    [0,0] => 'right',
    [3,0] => 'right',
    [4,0] => 'right',
    [6,0] => 'right',
    [7,0] => 'right',
  }
end
    end
  end
end
