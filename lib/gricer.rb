require "gricer/config"
require "gricer/engine"
require "gricer/localization"

require 'gricer/action_controller/base'
require 'gricer/action_controller/track'

require 'gricer/active_model/statistics'

module Gricer
  class << self    
    # To access the actual configuration of your Gricer, you can call this.
    #
    # An example would be <tt>Gricer.config.table_name_prefix = 'stats_'</tt>
    #
    # See Gricer::Config for configuration options.
    def config
      @config ||= Config.new
    end
    
    def configure(&block)
      config.configure(&block)
    end
  end
end