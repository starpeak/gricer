source "http://rubygems.org"

gemspec

if true
  gem "rails",              '~>3.2.1'
else
  gem "rails",              '~>3.1.3'

  # Gems used only for assets and not required
  # in production environments by default.
  group :assets do
   gem 'sass-rails',       '~> 3.1'
   gem 'compass-rails'
   gem 'coffee-rails',     '~> 3.1'
   gem 'uglifier'
 end
 
 gem 'jquery-rails'
end

# SQLite and PG for ActiveRecord flavoured model tests
gem 'sqlite3'
gem 'pg'
# Mongoid for Mongoid flavoured model tests
gem "mongoid", ">= 2.4"
gem "bson_ext", ">= 1.5"

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

group :development do
  gem 'pry'
  gem 'yard'
end

group :test, :development do
  # gem 'ruby-debug19', require: 'ruby-debug'
  gem 'fabrication'
  gem 'launchy'
  gem 'faker'
  gem 'chronic'
  gem 'syntax'
  gem 'timecop'
  gem 'jasminerice'
  gem 'guard-shell'
  
  if RUBY_PLATFORM =~ /darwin/i
    gem 'growl_notify'
    gem 'rb-fsevent', :require => false
  end
end
