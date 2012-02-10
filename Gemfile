source "http://rubygems.org"

gemspec

gem "rails",              '~>3.2.1'
# SQLite for ActiveRecord flavoured models
gem 'sqlite3'
# Mongoid for Mongoid flavoured models
gem "mongoid", ">= 2.4"
gem "bson_ext", ">= 1.5"

# Gems used only for assets and not required
# in production environments by default.
# group :assets do
#   gem 'sass-rails',       '~> 3.2.3'
#   gem 'compass-rails'
#   gem 'coffee-rails',     '~> 3.2.1'
#   gem 'uglifier',         '>= 1.0.3'
# end

# gem 'jquery-rails'

group :test do
  gem 'rspec-rails', '>= 2.8.1'
  gem 'mongoid-rspec'
  gem 'email_spec'
  gem 'webrat'
  gem 'capybara'
  gem 'cucumber-rails'
  gem 'database_cleaner'
  gem 'jasmine'
end

group :test, :development do
  # gem 'ruby-debug19', require: 'ruby-debug'
  gem 'pry'
  gem 'fabrication'
  gem 'launchy'
  gem 'faker'
  gem 'chronic'
  gem 'syntax'
  gem 'timecop'
  gem 'jasminerice'
  gem 'guard-shell'
  gem 'yard'
  
  if RUBY_PLATFORM =~ /darwin/i
    gem 'growl_notify'
    gem 'rb-fsevent', :require => false
  end
end
