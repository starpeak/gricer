module Gricer
  class Request < ::ActiveRecord::Base
    set_table_name "#{::Gricer::config.table_name_prefix}requests"
    include ActiveModel::Statistics
    
    belongs_to :session, class_name: 'Gricer::Session', counter_cache: true
    belongs_to :agent, class_name: 'Gricer::Agent', counter_cache: true
    
    before_create :init_session
    
    def self.browsers
      includes("agent")
      .where("\"#{Agent.table_name}\".\"agent_class_id\" IN (?)", [0x1000, 0x2000])
    end
    
    def self.only_first_in_session
      where('is_first_in_session = ?', true)
    end
    
    def ip_address=(ip)
      @ip_address = ip
    end
    
    def agent_header=(agent_header)
      self.agent = Agent.find_or_create_by_request_header agent_header
    end
    
    def request=(request)
      logger.debug 'request='
      
      self.ip_address   = request.remote_ip
      self.agent_header = request.headers['HTTP_USER_AGENT']
      self.referer      = request.headers['HTTP_X_FORWARDED_REFERER'] || request.headers['HTTP_REFERER']
      
      logger.debug '(1)'
      
      self.host         = request.host
      self.path         = request.path
      self.method       = request.request_method
      self.protocol     = request.protocol.sub(/[:\/]*$/, '').upcase
      self.locale       = I18n.locale
      
      logger.debug '(2)'
      
      @request_locale   = request.headers['HTTP_ACCEPT_LANGUAGE'].try(:split, ',').try(:first)
      
      logger.debug I18n.locale
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
    
    def referer=(referer)
      if referer
        void, self.referer_protocol, self.referer_host, self.referer_path, self.referer_params = referer.match(/([A-Za-z0-9]*):\/\/([^\/]*)([^\?]*)[\?]?(.*)/).to_a
        
        # Sanatize/Normalize referer values
        self.referer_protocol = referer_protocol.try(:upcase)
        self.referer_host = referer_host.try(:downcase)
        self.referer_path = '/' if referer_path.blank?
        self.referer_params = nil if referer_params.blank?
        
        # Detect Search Engines
        if referer_host =~ /^www\.google(?:\.com?)?(?:\.[a-z]{2})?$/ and ['/search', '/url'].include? referer_path
          self.search_engine = 'Google'
          params = CGI::parse(referer_params)
          self.search_query = params['q'].try(:first)    
        elsif referer_host == 'www.bing.com' and referer_path == '/search'
          self.search_engine = 'Bing'
          params = CGI::parse(referer_params)
          self.search_query = params['q'].try(:first)
        elsif referer_host =~ /search\.yahoo\.com$/ and referer_path =~ /\/search;/
          self.search_engine = 'Yahoo'
          params = CGI::parse(referer_params)
          self.search_query = params['p'].try(:first)
        elsif referer_host == 'www.baidu.com' and referer_path == '/s'
          self.search_engine = 'Baidu'
          params = CGI::parse(referer_params)
          self.search_query = params['wd'].try(:first)
        elsif referer_host =~ /ask\.com$/ and referer_path =~ /^\/web/
          self.search_engine = 'Ask'
          params = CGI::parse(referer_params)
          self.search_query = params['q'].try(:first)
        elsif referer_host == 'search.aol.com' and referer_path == '/aol/search'
          self.search_engine = 'AOL'
          params = CGI::parse(referer_params)
          self.search_query = params['q'].try(:first)
        elsif referer_host == 'www.metacrawler.com' and referer_path =~ /search\/web/
          self.search_engine = 'MetaCrawler'
          params = CGI::parse(referer_params)
          self.search_query = params['q'].try(:first)
        elsif referer_host == 'www.dogpile.com' and referer_path =~ /dogpile\/ws\/results\/Web\//
          self.search_engine = 'Dogpile'
          void, self.search_query = referer_path.match(/ws\/results\/Web\/([^\/]*)\//).to_a
          self.search_query = CGI::unescape(self.search_query)
        end
      end
    end
    
    def params=(params)
      self.param_id = params[:id]
      self.format = params[:format]
    end
    
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
    end
  end
end