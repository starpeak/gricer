module Gricer
  if defined? Mongoid
    module Mongoid
      class Session
        include ::Mongoid::Document
        include ::Mongoid::Timestamps
        include Mongoid::CounterCache
        include Mongoid::Touch
        include Mongoid::MapReduce
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
          any_in agent_id: Gricer::Mongoid::Agent.browsers.only(:id).map{|x| x.id}
        end
        
        def self.first_by_id(id)
          where('_id' => id).first
        end  
      
        # Get the average duration of sessions in seconds.
        #
        # @return [Float]
        def self.avg_duration
          map = "function() { emit(this.id, new Date(this.updated_at) - new Date(this.created_at)) }"
          reduce = "function (_, xs) { var x = {sum: 0, count: 0}; for (var i=0; i<xs.length; i++) { x.sum += xs[i]; x.count ++ } return x }"
          finalize = "function (_, x) {return x.sum / x.count }"
        
          result = map_reduce map, reduce, finalize: finalize
        
          return 0.0 unless result["results"][0]
        
          duration = result["results"][0]["value"] / 1000
        
          duration.nan? ? 0.0 : duration
        end   
      end
    end
  end
end