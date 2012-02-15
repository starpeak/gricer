module Gricer
  module Mongoid
    class Session
      include ::Mongoid::Document
      include ::Mongoid::Timestamps
      include Mongoid::CounterCache
      include Mongoid::Touch
      include ActiveModel::Session
      include ActiveModel::Statistics
      
      field :requests_count, type: Integer
      
      field :ip_address_hash, type: String
      field :domain, type: String
      
      field :country, type: String
      field :region, type: String
      field :city, type: String
      field :postal_code, type: String
      field :longitude, type: Float
      field :latitude, type: Float
      
      field :javascript, type: Boolean
      field :java, type: Boolean
      field :flash_version, type: String
      field :flash_major_version, type: String
      field :silverlight_version, type: String
      field :silverlight_major_version, type: String
      field :screen_width, type: Integer
      field :screen_height, type: Integer
      field :screen_size, type: String
      field :screen_depth, type: Integer
      field :requested_locale_major, type: String
      field :requested_locale_minor, type: String
      
      has_many :requests, class_name: 'Gricer::Mongoid::Request', foreign_key: :session_id, order: 'created_at ASC'
      belongs_to :agent, class_name: 'Gricer::Mongoid::Agent', foreign_key: :agent_id, counter_cache: true
      belongs_to :previous_session, class_name: 'Gricer::Mongoid::Session', foreign_key: :previous_session_id
    
      # Filter out anything that is not a Browser or MobileBrowser
      # @return [Mongoid::Criteria]
      def self.browsers
        #self.all.select {|session| [:browser, :mobile_browser].include? session.agent.agent_class }
        #self.collection.map_reduce 
        scoped
      end
        
      # Get the average duration of sessions in seconds.
      #
      # @return [Float]
      def self.avg_duration
        # if (c = self.count) > 0
        #    #logger.debug ActiveRecord::Base.connection.class
        #  
        #    if ::ActiveRecord::Base.connection.class.to_s == 'ActiveRecord::ConnectionAdapters::PostgreSQLAdapter'
        #      self.sum("date_part('epoch', \"#{self.table_name}\".\"updated_at\") - date_part('epoch', \"#{self.table_name}\".\"created_at\")").to_f / c.to_f    
        #    else
        #      self.sum("strftime('%s', \"#{self.table_name}\".\"updated_at\") - strftime('%s', \"#{self.table_name}\".\"created_at\")") / c.to_f
        #    end
        #  else
        #    0
        #  end
        
        0
       end
      
    end
  end
end