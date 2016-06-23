source 'https://rubygems.org'

gem 'odba'
gem 'tmail'
gem 'xmlconv'
gem 'minitest'
gem 'flexmock'
group :debugger do
  if RUBY_VERSION.match(/^1/)
    gem 'pry-debugger'
  else
    gem 'pry-byebug'
    gem 'pry-doc'
  end
end

group :test do
  gem 'rspec'
  gem 'watir'
  gem 'watir-webdriver'
end