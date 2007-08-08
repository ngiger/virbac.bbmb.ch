#!/usr/bin/env ruby
# Html::View::CurrentOrder -- de.oddb.org -- 16.04.2007 -- hwyss@ywesee.com

require 'bbmb/html/view/catalogue'
require 'bbmb/html/view/current_order'
require 'bbmb/html/view/promotions'

module BBMB
  module Html
    module View
class CurrentPriorities < HtmlGrid::Composite
  COMPONENTS = {
    [0,0]		=>	:priority,
    [0,1,0]		=>	:priority_0,
    [0,1,1]	=>	'priority_0',
    [0,2,0]		=>	:priority_1,
    [0,2,1]	=>	'priority_1',
    [1,2]		=>	'priority_explain_1',
    [0,3,0]		=>	:priority_13,
    [0,3,1]	=>	'priority_13',
    [1,3]		=>	'priority_explain_13',
    [0,4,0]		=>	:priority_16,
    [0,4,1]	=>	'priority_16',
    [1,4]		=>	'priority_explain_16',
    [0,5,0]		=>	:priority_21,
    [0,5,1]	=>	'priority_21',
    [1,5]		=>	'priority_explain_21',
  }
end
class CurrentPositions
  include CatalogueMethods
  include PromotionMethods
  COMPONENTS = {
    [0,0]  =>  :delete_position,
    [1,0]  =>  :quantity,
    [2,0]  =>  :promotions,
    [3,0]  =>  :description,
    [4,0]	 =>	 :catalogue1,
    [4,1]	 =>	 :catalogue2,
    [5,0]  =>  :backorder,
    [6,0]  =>  :price_base,
    [7,0]  =>  :price_levels,
    [8,0]  =>  :price2,
    [7,1]  =>  :price3,
    [8,1]  =>  :price4,
    [9,0]  =>  :price,
    [10,0] =>  :total,
    [11,0] =>  :vat,
  }
  CSS_MAP = {
    [0,0]     => 'delete',
    [1,0]     => 'tiny right',
    [3,0]     => 'description',
    [6,0,4,2] => 'right stable',
    [10,0]    => 'total stable',
    [11,0]    => 'right',
  }
  CSS_HEAD_MAP = {
    [1,0]  => 'right',
    [6,0]  => 'right',
    [7,0]  => 'right',
    [9,0]  => 'right',
    [10,0] => 'right',
    [11,0] => 'right',
  }
end
class CurrentOrderForm
  def toggle_status(model)
    'open'
  end
end
class CurrentOrder
  DOJO_REQUIRE.push('dojo.widget.Tooltip')
end
    end
  end
end
