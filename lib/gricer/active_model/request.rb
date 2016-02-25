module Gricer
  # Gricer's ActiveModel enhancements
  module ActiveModel
    module Request
      
      
      # Extend the ActiveModel with the statistics class methods.
      # @see ClassMethods
      def self.included(base)
        base.extend ClassMethods
      end
      
      module ClassMethods
      
        # Filter out anything that has not the first_in_session flag
        # @return [ActiveRecord::Relation/Mongoid::Criteria]
        def only_first_in_session
          where(is_first_in_session: true)
        end
        
      end
      
      # Parse the Ruby on Rails request to fill attributes
      def request=(request)  
        return if request.blank?
        info = Gricer::Parsers::Request.get_info request
        @request_locale = info.delete :req_locale
        self.attributes = info       
      end
      
      # Store the ip address from which the request was sent for init_session
      # @see #init_session
      def ip_address=(ip)
        @ip_address = ip
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
      
      # Find or Create Gricer::Agent corrosponding to the given user agent string as given in the HTTP header
      #
      # @param agent_header [String] A user agent string as in a HTTP header
      # @return [Gricer::Agent]
      def agent_header=(agent_header)
        self.agent = "Gricer::#{model_type}::Agent".constantize.find_or_create_by request_header: agent_header
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
          self.referer_params = '' if referer_params.blank?
          params = CGI::parse(referer_params) 
        
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
      
    end
  end
end