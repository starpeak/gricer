# Capybara.run_server = true #Whether start server when testing
# Capybara.default_selector = :xpath #default selector , you can change to :css
# Capybara.default_wait_time = 2 #When we testing AJAX, we can set a default wait time
# Capybara.ignore_hidden_elements = false #Ignore hidden elements when testing, make helpful when you hide or show elements using javascript
# Capybara.javascript_driver = :culerity #default driver when you using @javascript tag
# Capybara.javascript_driver = :selenium

# Capybara.register_driver :selenium_chrome do |app|
#   Capybara::Selenium::Driver.new(app, :browser => :chrome)
# end
# Capybara.javascript_driver = :selenium_chrome

Capybara.ignore_hidden_elements = true