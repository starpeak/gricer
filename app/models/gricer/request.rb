module Gricer
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
    set_table_name "#{::Gricer::config.table_name_prefix}requests"
    include ActiveModel::Statistics
    
    belongs_to :session, class_name: 'Gricer::Session', counter_cache: true
    belongs_to :agent, class_name: 'Gricer::Agent', counter_cache: true
    
    before_create :init_session
    
    # Filter out anything that is not a Browser or MobileBrowser
    # @return [ActiveRecord::Relation]
    def self.browsers
      includes("agent")
      .where("\"#{Agent.table_name}\".\"agent_class_id\" IN (?)", [0x1000, 0x2000])
    end
    
    # Filter out anything that has not the first_in_session flag
    # @return [ActiveRecord::Relation]
    def self.only_first_in_session
      where('is_first_in_session = ?', true)
    end
    
    # Store the ip address from which the request was sent for init_session
    # @see #init_session
    def ip_address=(ip)
      @ip_address = ip
    end
    
    # Find or Create Gricer::Agent corrosponding to the given user agent string as given in the HTTP header
    #
    # @param agent_header [String] A user agent string as in a HTTP header
    # @return [Gricer::Agent]
    def agent_header=(agent_header)
      self.agent = Agent.find_or_create_by_request_header agent_header
    end
    
    # Parse the Ruby on Rails request to fill attributes
    def request=(request)  
      self.ip_address   = request.remote_ip
      self.agent_header = request.headers['HTTP_USER_AGENT']
      self.referer      = request.headers['HTTP_X_FORWARDED_REFERER'] || request.headers['HTTP_REFERER']
      
      self.host         = request.host
      self.path         = request.path
      self.method       = request.request_method
      self.protocol     = request.protocol.sub(/[:\/]*$/, '').upcase
      self.locale       = I18n.locale
      
      @request_locale   = request.headers['HTTP_ACCEPT_LANGUAGE'].try(:split, ',').try(:first)
      
      #logger.debug I18n.locale
    end
    
    def locale=(locale)
      self.locale_major, self.locale_minor = locale.try(:to_s).try(:downcase).try(:split, '-')
    end
    
    def locale
      if locale_minor
        "#{locale_major}-#{locale_minor}"
      else
        locale_major
      end
    end
    
    # Parse the referer to fill referer and search engine attributes
    #
    # @param referer [String] The Referer as given in HTTP request
    def referer=(referer)
      if referer
        void, self.referer_protocol, self.referer_host, self.referer_path, self.referer_params = referer.match(/([A-Za-z0-9]*):\/\/([^\/]*)([^\?]*)[\?]?(.*)/).to_a
        
        # Sanatize/Normalize referer values
        self.referer_protocol = referer_protocol.try(:upcase)
        self.referer_host = referer_host.try(:downcase)
        self.referer_path = '/' if referer_path.blank?
        self.referer_params = nil if referer_params.blank?
        params = CGI::parse(referer_params) unless referer_params.blank?
        
        # Detect Search Engines
        if referer_host =~ /^www\.google(?:\.com?)?(?:\.[a-z]{2})?$/ and ['/search', '/url'].include? referer_path
          self.search_engine = 'Google'
          self.search_query = params['q'].try(:first)    
        elsif referer_host == 'www.bing.com' and referer_path == '/search'
          self.search_engine = 'Bing'
          self.search_query = params['q'].try(:first)
        elsif referer_host =~ /search\.yahoo\.com$/ and referer_path =~ /\/search;/
          self.search_engine = 'Yahoo'
          self.search_query = params['p'].try(:first)
        elsif referer_host == 'www.baidu.com' and referer_path == '/s'
          self.search_engine = 'Baidu'
          self.search_query = params['wd'].try(:first)
        elsif referer_host =~ /ask\.com$/ and referer_path =~ /^\/web/
          self.search_engine = 'Ask'
          self.search_query = params['q'].try(:first)
        elsif referer_host == 'search.aol.com' and referer_path == '/aol/search'
          self.search_engine = 'AOL'
          self.search_query = params['q'].try(:first)
        elsif referer_host =~ /metacrawler\.com$/ and referer_path =~ /search\/web/
          self.search_engine = 'MetaCrawler'
          self.search_query = params['q'].try(:first)
        elsif referer_host =~ /dogpile\.com/ and referer_path =~ /dogpile\/ws\/results\/Web\//
          self.search_engine = 'Dogpile'
          void, self.search_query = referer_path.match(/ws\/results\/Web\/([^\/]*)\//).to_a
          self.search_query = CGI::unescape(self.search_query).gsub('!FE', '.')
        end
      end
    end
    
    # Parse the params to fill param_id and format attributes
    def params=(params)
      self.param_id = params[:id]
      self.format = params[:format]
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