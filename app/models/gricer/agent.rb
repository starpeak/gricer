module Gricer  
  # ActiveRecord Model for User Agent Statistics
  # @attr [String] request_header
  #   The  current value of user agent string as within the HTTP request.
  #
  # @attr [String] name
  #   The current value of user agent's name.
  #   (e.g. 'Firefox', 'Chrome', 'Internet Explorer')
  #
  # @attr [String] full_version
  #   The current value of user agent's full version.
  #   This means it does include all sub version numbers.
  #
  # @attr [String] major_version
  #   The current value of user agent's major version.
  #   This means it does include only the first number after a dot.
  #
  # @attr [String] engine_name
  #   The current value of the name of the engine used by the user agent
  #
  # @attr [String] engine_version
  #   The current value of the version of the engine used by the user agent
  #
  # @attr [String] os
  #   The current value of the OS the user agent is hosted on.
  #
  # @attr [String] agent_class
  #   The current value of the classification of the user agent. 
  #
  #   See {AGENT_CLASSES} for possible values.
  class Agent < ::ActiveRecord::Base    
    self.table_name = "#{::Gricer::config.table_name_prefix}agents"
    include ActiveModel::Statistics
    
    has_many :requests, class_name: 'Gricer::Request', foreign_key: :agent_id, order: 'created_at ASC'
    has_many :sessions, class_name: 'Gricer::Session', foreign_key: :session_id, order: 'created_at ASC'
    
    before_create :calculate_agent_info
    
    # The agent class constant defines numeric values for the different agent types to be stored in a database.
    AGENT_CLASSES = {
      0x1000 => :browser,
      0x2000 => :mobile_browser,
      0x0001 => :bot
    }
    
    # Filter out anything that is not a Browser or MobileBrowser
    # @return [ActiveRecord::Relation]
    def self.browsers
      self.where("\"#{self.table_name}\".\"agent_class_id\" IN (?)", [0x1000, 0x2000])
    end
    

    def agent_class
      AGENT_CLASSES[agent_class_id]
    end
    
    def agent_class= class_name
      self.agent_class_id = nil
      AGENT_CLASSES.each do |key, value|
        if value == class_name
          self.agent_class_id = key
          break
        end
      end      
    end
    
    def calculate_agent_info    
      return if request_header.blank?
      self.attributes = Gricer::Parsers::Agent.get_info request_header
    end
  end
end