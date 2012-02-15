require "gricer/engine"

require 'gricer/action_controller/base'
require 'gricer/action_controller/track'

require 'gricer/active_model/statistics'
require 'gricer/active_model/session'
require 'gricer/active_model/request'

require 'gricer/mongoid/touch'
require 'gricer/mongoid/counter_cache'
require 'gricer/mongoid/map_reduce'

require 'sass'
require 'compass/rails'
require 'jquery/rails'

require 'gricer/config'
require 'gricer/parsers/agent'
require 'gricer/parsers/ip'
require 'gricer/parsers/request'


# Gricer is a web analytics gem for Rails 3.1 and beyond
module Gricer  
  class << self    
    # To access the actual configuration of your Gricer, you can call this function.
    #
    # An example would be <tt>Gricer.config.table_name_prefix = 'stats_'</tt>
    #
    # See Gricer::Config for configuration options.
    #
    # @return [Gricer::Config] The actual configuration instance of Gricer
    # @see Gricer::Config
    def config
      @config ||= Config.new
    end
    
    # To initialize Gricer it is handy to give it a block of options.
    #
    # See Gricer::Config for configuration options.
    #
    # @yield (config) The actual configuration instance of Gricer
    # @return [Gricer::Config] The actual configuration instance of Gricer
    # @see Gricer::Config
    def configure(&block)
      config.configure(&block)
    end
  end
end

require 'i18n'
I18n.load_path += Dir.glob("#{File.dirname(__FILE__)}/../../config/locales/*.yml")
I18n.backend.reload!