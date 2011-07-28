require 'spork'
 
Spork.prefork do   
  require 'cucumber/formatter/unicode'
  require 'cucumber/rails/world'
  require 'cucumber/web/tableish'
  
  require 'capybara/rails'
  require 'capybara/cucumber'
  require 'capybara/session'
  require 'cucumber/rails/capybara/javascript_emulation'
  
  require 'email_spec'
  require 'email_spec/cucumber'
  
  ActiveSupport::Dependencies.clear
end
 
Spork.each_run do
  Rails.application.reload_routes!
end