#!/usr/bin/env ruby
# Html::Util::Validator -- bbmb -- 11.04.2007 -- hwyss@ywesee.com

require 'bbmb/html/util/validator'

module VIRBAC
  module Html
    module Util
class Validator < BBMB::Html::Util::Validator
  BOOLEAN.push(:show_vat)
  EVENTS.push(:calculate, :calculator, :catalogue, :promotions, :quotas)
  NUMERIC.push(:factor)
  def category(value)
    value.split(',')
  end
end
    end
  end
end
