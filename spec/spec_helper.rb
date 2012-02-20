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

# Models for different SQL databases
module Models
  module PostgreSQL
    class Session < Gricer::ActiveRecord::Session
      establish_connection :test_pg
    end
    class Request < Gricer::ActiveRecord::Request
      establish_connection :test_pg
    end
    class Agent < Gricer::ActiveRecord::Agent
      establish_connection :test_pg
    end
  end

  module SQLite
    class Session < Gricer::ActiveRecord::Session
      establish_connection :test
    end
    class Request < Gricer::ActiveRecord::Request
      establish_connection :test
    end
    class Agent < Gricer::ActiveRecord::Agent
      establish_connection :test
    end
  end
end

def for_all_databases &block
  [
    [:ActiveRecord, :SQLite], 
    [:ActiveRecord, :PostgreSQL], 
    [:Mongoid, nil]
  ].each do |model_type|    
    model_type_group = context "Running for #{model_type[0]} models#{model_type[1] ? " with #{model_type[1]}" : ''}" do
      before :all do
        Gricer.config.model_type = model_type[0]
        if model_type[0] == :ActiveRecord
          [:Session, :Request, :Agent].each do |model|
            Gricer::ActiveRecord.send(:remove_const, model) if Gricer::ActiveRecord.const_defined?(model)
            Gricer::ActiveRecord.const_set(model, "Models::#{model_type[1]}::#{model}".constantize)
          end
        end
      end
      
      after :all do
        Gricer.config.model_type = :ActiveRecord
      end
      
      let(:model_type) { model_type[0] }
    end
    
    model_type_group.class_eval &block
  end
end