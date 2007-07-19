#!/usr/bin/env ruby
# Html::View::Login -- virbac.bbmb.ch -- 19.07.2007 -- hwyss@ywesee.com

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
    error_message
  end
end
class LoginForm < HtmlGrid::Form
  COMPONENTS = {
    [0,0] =>  :email,
    [0,1] =>  :pass,
    [1,2] =>  :submit,
    [0,3,0] =>  :delivery_conditions,
    [0,3,1] =>  :delivery_conditions_text,
    [0,4,0] =>  :business_conditions,
    [0,4,1] =>  :business_conditions_text,
    [0,5] =>  :new_customer,
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
    conditions('business')
  end
  def business_conditions_text(model)
    conditions_text('business', model)
  end
  def conditions(key)
    msg = @lookandfeel.lookup("#{key}_conditions")
    attrs = {
      'css_class'     => 'login-foot',
      'message_open'  => msg, 
      'message_close' => msg, 
      'status'        => 'closed',
      'togglee'       => "#{key}-conditions",
    }
    dojo_tag('contenttoggler', attrs)
  end
  def conditions_text(key, model)
    div = HtmlGrid::Div.new(model, @session, self)
    div.value = @lookandfeel.lookup("#{key}_conditions_text")
    div.css_id = "#{key}-conditions"
    div
  end
  def delivery_conditions(model)
    conditions('delivery')
  end
  def delivery_conditions_text(model)
    conditions_text('delivery', model)
  end
  def new_customer(model)
    msg = @lookandfeel.lookup(:new_customer_invite).gsub("\n", '<br>')
    status = (@session.event == :request_access) ? 'open' : 'closed'
    attrs = {
      'css_class'     => 'new-customer',
      'message_open'  => msg, 
      'message_close' => msg, 
      'status'        => status,
      'togglee'       => 'new-customer',
    }
    tag = dojo_tag('contenttoggler', attrs)
    tag.label = true
    tag
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
  include HtmlGrid::DojoToolkit::DojoTemplate
  DOJO_DEBUG = BBMB.config.debug
  DOJO_PREFIX = {
    'ywesee' => '../javascript',
  }
  DOJO_REQUIRE = [ 'dojo.widget.*', 'ywesee.widget.*', 
    'ywesee.widget.ContentToggler' ]
end
    end
  end
end
