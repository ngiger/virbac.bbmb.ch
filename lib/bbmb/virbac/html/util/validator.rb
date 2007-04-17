#!/usr/bin/env ruby
# Html::Util::Validator -- bbmb -- 11.04.2007 -- hwyss@ywesee.com

require 'bbmb/html/util/validator'

module BBMB
  module Html
    module Util
class Validator
  EVENTS.push(:catalogue, :promotions, :quotas)
  def category(value)
    value.split(',')
  end
end
    end
  end
end
