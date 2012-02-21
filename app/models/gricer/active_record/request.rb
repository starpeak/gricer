module Gricer
  module ActiveRecord
    # ActiveRecord Model for Request Statistics
    # @attr [Gricer::Session] session
    #   The current value of the associated session.
    #
    # @attr [Gricer::Agent] agent
    #   The current value of the associated agent.
    #
    # @attr [String] host
    #   The current value of the host requested.
    #
    # @attr [String] path
    #   The current value of the path requested.
    #
    # @attr [String] method
    #   The current value of the method requested.
    #
    # @attr [String] protocol
    #   The current value of the protocol requested.
    #
    # @attr [String] controller
    #   The current value of the controller requested.
    #
    # @attr [String] action
    #   The current value of the action requested.
    #
    # @attr [String] format
    #   The current value of the format requested.
    #
    # @attr [String] param_id
    #   The current value of the http GET/POST id parameter requested.
    #
    # @attr [Integer] user_id
    #   The current id of the user logged in.
    #
    #   @see Gricer::ActionController::Base#gricer_user_id
    #
    # @attr [Integer] status_code
    #   The current value of the HTTP status returned.
    #
    # @attr [String] content_type
    #   The current value of the content type returned.
    #
    # @attr [String] body_size
    #   The current size of the body returned.
    #
    # @attr [String] system_time
    #   The current value of the system time elapsed processing this request.
    #
    # @attr [String] user_time
    #   The current value of the user time elapsed processing this request.
    #
    # @attr [String] total_time
    #   The current value of the total time elapsed processing this request.
    #
    # @attr [String] real_time
    #   The current value of the real time elapsed processing this request.
    #
    # @attr [Boolean] javascript
    #   The current value of the javascript capability of the requesting agent.
    #
    #   This feature needs the usage of {Gricer::TrackHelper#gricer_track_tag}.
    #
    # @attr [Integer] window_width
    #   The current value of the width in pixels of the requesting agent's window.
    #
    #   This feature needs the usage of {Gricer::TrackHelper#gricer_track_tag}.
    #
    # @attr [Integer] window_height
    #   The current value of the height in pixels of the requesting agent's window.
    #
    #   This feature needs the usage of {Gricer::TrackHelper#gricer_track_tag}.
    #
    # @attr [String] referer_protocol
    #   The current value of the protocol of the referering page.
    #
    # @attr [String] referer_host
    #   The current value of the host of the referering page.
    #
    # @attr [String] referer_path
    #   The current value of the path of the referering page.
    #
    # @attr [String] referer_params
    #   The current value of the params of the referering page.
    #
    # @attr [String] search_engine
    #   The current value of the search engine name refering to get to this request.
    #
    # @attr [String] search_query
    #   The current value of the search query refering to get to this request.
    #
    # @attr [Boolean] is_first_in_session
    #   The current value of the first in session flag.
    #   This is true if it is the first request within a Gricer::Session.
    #
    # @attr [String] locale_major
    #   The current value of the locale responded (major locale only)
    #
    # @attr [String] locale_minor
    #   The current value of the locale responded (major locale only)
    #
    # @attr [String] locale
    #   The current value of the locale responded 
    #
    class Request < ::ActiveRecord::Base
      self.table_name = "#{::Gricer::config.table_name_prefix}requests"
      include ActiveModel::Request
      include ActiveModel::Statistics
      include ActiveRecord::LimitStrings
    
      belongs_to :session, class_name: '::Gricer::ActiveRecord::Session', counter_cache: true
      belongs_to :agent, class_name: '::Gricer::ActiveRecord::Agent', counter_cache: true
    
      before_create :init_session
    
      # Filter out anything that is not a Browser or MobileBrowser
      # @return [ActiveRecord::Relation]
      def self.browsers
        includes("agent")
        .where("\"#{Agent.table_name}\".\"agent_class_id\" IN (?)", [0x1000, 0x2000])
      end
      
      def self.first_by_id(id)
        where(id: id).first
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