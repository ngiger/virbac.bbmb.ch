#!/usr/bin/env ruby
# Html::State::Quotas -- bbmb -- 11.04.2007 -- hwyss@ywesee.com

require 'bbmb/html/state/global'
require 'bbmb/html/view/quotas'

module BBMB
  module Html
    module State
class Quotas < Global
  DIRECT_EVENT = :quotas
  VIEW = Html::View::Quotas
end
    end
  end
end
