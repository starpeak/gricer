module Gricer
  module Mongoid
    class Agent
      include ::Mongoid::Document
      include ::Mongoid::Timestamps
      include ActiveModel::Statistics
      
      field :requests_count, type: Integer
      field :sessions_count, type: Integer
      
      field :request_header, type: String
      field :agent_class, type: String
      field :name, type: String
      field :full_version, type: String
      field :major_version, type: String
      field :minor_version, type: String
      field :engine_name, type: String
      field :engine_version, type: String
      field :os, type: String
      
      has_many :requests, class_name: 'Gricer::Mongoid::Request', foreign_key: :agent_id, order: 'created_at ASC'
      has_many :sessions, class_name: 'Gricer::Mongoid::Session', foreign_key: :session_id, order: 'created_at ASC'
      
      before_create :calculate_agent_info
      
      # Filter out anything that is not a Browser or MobileBrowser
      # @return [Mongoid::Criteria]
      def self.browsers
        self.all_in(:agent_class, [:browser, :mobile_browser])
      end
      
      def calculate_agent_info    
        return if request_header.blank?
        self.attributes = Gricer::Parsers::Agent.get_info request_header
      end
    end
  end
end