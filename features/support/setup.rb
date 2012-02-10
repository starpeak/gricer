require 'cucumber/formatter/unicode'
require 'cucumber/rails/world'

require 'capybara/rails'
require 'capybara/cucumber'
require 'capybara/session'
require 'cucumber/rails/capybara/javascript_emulation'

require 'email_spec'
require 'email_spec/cucumber'

ActiveSupport::Dependencies.clear

Rails.application.reload_routes!
