#!/usr/bin/env ruby
# Html::View::Quotas -- bbmb -- 11.04.2007 -- hwyss@ywesee.com

require 'bbmb/html/view/template'
require 'htmlgrid/datevalue'

module BBMB
  module Html
    module View
class QuotasComposite < HtmlGrid::List
  BACKGROUND_ROW = 'bg'
  BACKGROUND_SUFFIX = ''
  COMPONENTS = {
    [0,0] => :description,
    [1,0] => :start_date,
    [2,0] => :end_date,
    [3,0] => :target,
    [4,0] => :actual,
    [5,0] => :difference,
    [6,0] => :price,
  }
  CSS_CLASS = 'list'
  CSS_HEAD_MAP = {
    [1,0] => 'right',
    [2,0] => 'right',
    [3,0] => 'right',
    [4,0] => 'right',
    [5,0] => 'right',
    [6,0] => 'right',
  }
  CSS_MAP = {
    [0,0] => 'description',
    [1,0,6] => 'right',
  }
  SORT_DEFAULT = :description
  SYMBOL_MAP = {
    :end_date   => HtmlGrid::DateValue,
    :start_date => HtmlGrid::DateValue,
  } 
end
class Quotas < Template
  CONTENT = QuotasComposite
end
    end
  end
end
