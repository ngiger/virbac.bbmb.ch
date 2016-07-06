source 'https://rubygems.org'

gem 'odba'
gem 'bbmb'
gem 'spreadsheet'

group :debugger do
  if RUBY_VERSION.match(/^1/)
    gem 'pry-debugger'
  else
    gem 'pry-byebug'
    gem 'pry-doc'
  end
end

group :test do
  gem 'test-unit'
  gem 'minitest'
  gem 'flexmock'
  gem 'rspec'
  gem 'watir'
  gem 'watir-webdriver'
end