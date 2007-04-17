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
end
    end
  end
end
