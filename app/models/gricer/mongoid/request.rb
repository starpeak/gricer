module Gricer
  if defined? ::Mongoid
    module Mongoid
      class Request
        include ::Mongoid::Document
        include ::Mongoid::Timestamps
        include Mongoid::CounterCache
        include ActiveModel::Request
        include ActiveModel::Statistics
      
        field :host, type: String
        field :path, type: String
        field :method, type: String
        field :protocol, type: String
        field :controller, type: String
        field :action, type: String
        field :format, type: String
        field :param_id, type: String
        #field :user_id, type: 
        field :status_code, type: Integer
        field :content_type, type: String
        field :body_size, type: Integer
      
        field :system_time, type: Integer
        field :user_time, type: Integer
        field :total_time, type: Integer
        field :real_time, type: Integer
      
        field :javascript, type: Boolean
        field :window_width, type: Integer
        field :window_height, type: Integer
      
        field :referer_protocol, type: String
        field :referer_host, type: String
        field :referer_path, type: String
        field :referer_params, type: String
        field :search_engine, type: String
        field :search_query, type: String
      
        field :is_first_in_session, type: Boolean, default: false
      
        field :locale_major, type: String
        field :locale_minor, type: String
      
        belongs_to :session, class_name: 'Gricer::Mongoid::Session', counter_cache: true
        belongs_to :agent, class_name: 'Gricer::Mongoid::Agent', counter_cache: true

        default_scope { order(created_at: :asc) }
              
        before_create :init_session
      
        # Filter out anything that is not a Browser or MobileBrowser
        # @return [Mongoid::Criteria]
        def self.browsers
          any_in agent_id: Gricer::Mongoid::Agent.browsers.only(:id).map{|x| x.id}
        end
    
        def self.first_by_id(id)
          where('_id' => id).first
        end  
      
        # Find or Create Gricer::Agent corrosponding to the given user agent string as given in the HTTP header
        #
        # @param agent_header [String] A user agent string as in a HTTP header
        # @return [Gricer::Agent]
        def agent_header=(agent_header)
          self.agent = "Gricer::#{model_type}::Agent".constantize.find_or_create_by request_header: agent_header
        end
      

        # Init the corrosponding Gricer::Session (called before create)
        #
        # @return [Gricer::Session]
        def init_session
          if session
            if session.updated_at < Time.now - ::Gricer.config.max_session_duration
              self.session = Session.create previous_session: session, ip_address: @ip_address, agent: agent, requested_locale: @request_locale
            else
              self.session.touch
            end
          else
            self.is_first_in_session = true
            self.session = Session.create ip_address: @ip_address, agent: agent, requested_locale: @request_locale
            self.session.touch
          end
      
          session
        end
      
      end
    end
  end
end