ENV["RAILS_ENV"] = "test"

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require 'rspec/rails'

Rails.backtrace_cleaner.remove_silencers!

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.mock_with :rspec
  config.use_transactional_fixtures = true
end

Rails.application.reload_routes!
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }  


def silence_streams(*streams)
  on_hold = streams.collect { |stream| stream.dup }
  streams.each do |stream|
    stream.reopen(RUBY_PLATFORM =~ /mswin/ ? 'NUL:' : '/dev/null')
    stream.sync = true
  end
  yield
ensure
  streams.each_with_index do |stream, i|
    stream.reopen(on_hold[i])
  end
end