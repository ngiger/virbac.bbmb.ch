#!/usr/bin/env ruby
# Html::View::Catalogue -- bbmb -- 16.04.2007 -- hwyss@ywesee.com

require 'bbmb/html/util/multilingual'
require 'bbmb/html/view/template'

module BBMB
  module Html
    module View
module CatalogueMethods
  def catalogue1(model)
    search_link(model, model.catalogue1)
  end
  def catalogue2(model)
    search_link(model, model.catalogue1, model.catalogue2)
  end
  def search_link(model, *values)
    value = values.join(',')
    link = HtmlGrid::Link.new(:catalogue, model, @session, self)
    link.href = @lookandfeel._event_url(:catalogue, :category => value)
    link.value = values.last
    link
  end
end
class CatalogueList < HtmlGrid::List
  include Util::Multilingual
  BACKGROUND_SUFFIX = ''
  COMPONENTS = { 
    [0,0] => :link,
    [1,0] => :catalogue,
  }
  CSS_MAP = {
    [1,0] => 'catalogue',
  }
  OMIT_HEADER = true
  SORT_DEFAULT = nil
  def init
    @category, @model = @model
    super
  end
  def catalogue(model)
    cat = @session.persistent_user_input(:category) || []
    if(model.is_a?(Array) && cat.include?(model.first))
      CatalogueList.new(model, @session, self)
    end
  end
  def categories
    if(@container.respond_to?(:categories))
      @container.categories.push(@category)
    else
      [@category].compact
    end
  end
  def link(model)
    link = HtmlGrid::Link.new(:description, model, @session, self)
    if(model.is_a?(Array))
      nxt = model.first
      cat = categories.push(nxt).join(',')
      link.href = @lookandfeel._event_url(:catalogue, :category => cat)
      link.value = nxt
    else
      quantity = 'quantity[%s]' % model.article_number
      link.value = _(model.description)
      link.href = @lookandfeel._event_url(:increment_order, 
                                          quantity => 1)
    end
    link
  end
end
class CatalogueComposite < HtmlGrid::DivComposite
  COMPONENTS = {
    [0,0] => 'catalogue',
    [0,1] => :catalogue,
  }
  CSS_ID_MAP = [ 'title', 'catalogue' ]
  def catalogue(model)
    CatalogueList.new([nil, model], @session, self)
  end
end
class Catalogue < Template
  CONTENT = CatalogueComposite
end
    end
  end
end
