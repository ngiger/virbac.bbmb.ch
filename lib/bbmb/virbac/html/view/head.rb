#!/usr/bin/env ruby
# Html::View::head -- bbmb -- 09.08.2007 -- hwyss@ywesee.com

module BBMB
  module Html
    module View
class Head
  COMPONENTS = {
    [0,1] => :logo,
    [0,0] => :language_chooser,
    [0,3] => 'welcome',
    [0,2] => :logged_in_as, # has float-right, needs to be before 'welcome'
  }
  CSS_ID_MAP = {0 => 'language-chooser', 3 => 'welcome', 2 => 'logged-in-as'}
  def language_chooser(model)
    current = @session.language
    @lookandfeel.languages.collect { |lang|
      link = HtmlGrid::Link.new(lang, model, @session, self)
      unless(lang == current)
        path = @session.request_path.dup
        base = "/#{lang}/"
        path.sub!(%r{/#{current}/?}, base) || path = base
        link.href = path
      end
      link
    }
  end
end
    end
  end
end
