#!/usr/bin/env ruby
# Html::View::Favorites -- bbmb -- 17.04.2007 -- hwyss@ywesee.com

require 'bbmb/html/view/catalogue'
require 'bbmb/html/view/favorites'
require 'bbmb/html/view/promotions'

module BBMB
  module Html
    module View
class FavoritesPositions
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
    [9,0]  =>  :total,
  }
  CSS_MAP = {
    [0,0]     => 'delete',
    [1,0]     => 'tiny right',
    [3,0]     => 'description',
    [6,0,3,2] => 'right',
    [9,0]     => 'total',
  }
  CSS_HEAD_MAP = {
    [1,0]  => 'right',
    [6,0]  => 'right',
    [7,0]  => 'right',
    [9,0]  => 'right',
  }
end
class Favorites
  DOJO_REQUIRE.push('dojo.widget.Tooltip')
end
    end
  end
end
