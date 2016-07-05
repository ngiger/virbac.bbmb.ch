#!/usr/bin/env ruby
# Html::View::Login -- virbac.bbmb.ch -- 19.07.2007 -- hwyss@ywesee.com

require 'cgi'
module BBMB
  module Html
    module View
class NewCustomerForm < HtmlGrid::Form
  include HtmlGrid::ErrorMessage
  COMPONENTS = {
    [0,0] => :firstname,
    [0,1] => :lastname,
    [0,2] => :organisation,
    [0,3] => :address1,
    [0,4] => :plz,
    [0,5] => :city,
    [0,6] => :phone_business,
    [0,7] => :email,
    [0,8] => :customer_id,
    [1,9] => "new_customer_thanks",
    [1,10]=> :submit,
  }
  CSS_ID = 'new-customer-form'
  EVENT = :request_access
  LABELS = true
  LOOKANDFEEL_MAP = {
    :customer_id => :customer_or_tsv_id,
  }
  def init
    super
    set_attribute('hidden', (@session.event == :request_access) ? 'true' : 'false')
    error_message
  end
end
class LoginForm < HtmlGrid::Form
  COMPONENTS = {
    [0,0] =>  :email,
    [0,1] =>  :pass,
    [1,2] =>  :submit,
    [0,3] =>  :delivery_conditions,
    [0,4] =>  :business_conditions,
    [0,5] =>  :new_customer,
    [1,5] =>  :new_customer_invite,
  }
  CSS_MAP = {
    [0,3,2]   => 'login-foot',
    [0,4,1,2] => 'top',
  }
  COLSPAN_MAP = {
    [0,3] => 2,
    [0,4] => 2,
  }

  def business_conditions(model)
    content_toggler(model, 'business_conditions')
  end
  def content_toggler(model, key, status=false)
    togglee = "#{key}_text"
    link = HtmlGrid::Link.new("#{key}", model, @session, self)
    link.css_id = key
    link.value = @lookandfeel.lookup(key)
    div = HtmlGrid::Div.new(model, @session, self)
    div.css_id = togglee
    div.set_attribute('hidden', status ? 'true' : 'false')
    div.value = @lookandfeel.lookup(togglee)
    script = "event.preventDefault();
var element = document.getElementById('#{togglee}');
// console.log('onclick: #{togglee} hidden '+ document.getElementById('#{togglee}').hidden);
element.hidden = !element.hidden;
"
    link.set_attribute("onclick", script)
    [link, div]
  end

  def delivery_conditions(model)
    return content_toggler(model, 'delivery_conditions')
  end

  def new_customer(model)
    HtmlGrid::LabelText.new(:new_customer, model, @session, self)
  end
  def new_customer_invite(model)
    togglee = 'new-customer-form'
    link = HtmlGrid::Link.new(:new_customer_invite, model, @session, self)
    script = "
var element = document.getElementById('#{togglee}');
// console.log('new_customer_invite onclick second2: #{togglee} hidden '+ element.hidden);
if (document.getElementById('#{togglee}').hidden) {
  document.getElementById('#{togglee}').hidden = false;
} else {
  document.getElementById('#{togglee}').hidden = true;
}
"
    link.set_attribute("onclick", script)
    link
  end
end
class LoginComposite < HtmlGrid::DivComposite
  COMPONENTS = {
    [0,0] => LoginForm,
    [0,1] => NewCustomerForm,
  }
  CSS_ID_MAP = { 1 => 'new-customer' }
end
class Login < Template
  # we want to disable dojo completely
  DOJO_PREFIX = {}
  DOJO_REQUIRE = []
end
    end
  end
end
