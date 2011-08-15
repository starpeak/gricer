module Gricer
  # The configuration object for Gricer
  #
  # 
  class Config
    attr_writer :table_name_prefix, :admin_prefix, :admin_layout 
    attr_writer :max_session_duration
    attr_writer :geoip_db, :geoip_dat 
    attr_writer :exclude_paths 
    attr_writer :admin_menu 
    
    # A new instance of Gricer::Config.
    #
    # Configure options can be passed in a block.
    #
    # @see #configure
    #
    # @return [Gricer::Config] 
    def initialize(&block)
      configure(&block) if block_given?
    end

    # Configure your Gricer Rails Engine with the given parameters in 
    # the block. For possible options see Instance Attributes.
    #
    # @yield (config) The actual configuration instance
    # @return [Gricer::Config] The actual configuration instance
    def configure(&block)
      yield(self)
    end
    
    # The prefix for table names of gricer database tables.
    #
    # Default value is 'gricer_'
    # @return [String] 
    def table_name_prefix 
      @table_name_prefix ||= 'gricer_'
    end
    
    # Configure the prefix for admin pages paths
    #
    # Default value is 'gricer'    
    # @return [String] 
    def admin_prefix
      @admin_prefix.blank? ? 'gricer' : @admin_prefix
    end
    
    # Configure to use another layout than the application default for Gricer controllers
    #
    # Default value is nil
    # @return [String] 
    def admin_layout 
      @admin_layout
    end
    
    # Configure the structure of Gricer's admin menu
    #
    # Default value see source
    # @return [Array] 
    def admin_menu 
      @admin_menu ||= [
        ['Overview', :dashboard, {controller: 'gricer/dashboard', action: 'overview'}],
        ['Visitors', :menu, [
          ['Entry Pages', :spread, {controller: 'gricer/requests', action: 'spread_stats', field: 'entry_path'}],
          ['Referers', :spread, {controller: 'gricer/requests', action: 'spread_stats', field: 'referer_host'}],
          ['Search Engines', :spread, {controller: 'gricer/requests', action: 'spread_stats', field: 'search_engine'}],
          ['Search Terms', :spread, {controller: 'gricer/requests', action: 'spread_stats', field: 'search_query'}],
          ['Countries', :spread, {controller: 'gricer/sessions', action: 'spread_stats', field: 'country'}],
          ['Domains', :spread, {controller: 'gricer/sessions', action: 'spread_stats', field: 'domain'}],
          ['Locales', :spread, {controller: 'gricer/sessions', action: 'spread_stats', field: 'requested_locale_major'}]
        ] ],
        ['Pages', :menu, [
          ['Views', :spread, {controller: 'gricer/requests', action: 'spread_stats', field: 'path'}],
          ['Hosts', :spread, {controller: 'gricer/requests', action: 'spread_stats', field: 'host'}],
          ['Methods', :spread, {controller: 'gricer/requests', action: 'spread_stats', field: 'method'}],
          ['Protocols', :spread, {controller: 'gricer/requests', action: 'spread_stats', field: 'protocol'}],
        ] ],
        ['Browsers', :menu, [
          ['Browsers', :spread, {controller: 'gricer/sessions', action: 'spread_stats', field: 'agent.name'}],
          ['Operating Systems', :spread, {controller: 'gricer/sessions', action: 'spread_stats', field: 'agent.os'}],
          ['Engines', :spread, {controller: 'gricer/sessions', action: 'spread_stats', field: 'agent.engine_name'}],
          ['JavaScript', :spread, {controller: 'gricer/sessions', action: 'spread_stats', field: 'javascript'}],
          ['Java', :spread, {controller: 'gricer/sessions', action: 'spread_stats', field: 'java'}],
          ['Silverlight', :spread, {controller: 'gricer/sessions', action: 'spread_stats', field: 'silverlight_major_version'}],
          ['Flash', :spread, {controller: 'gricer/sessions', action: 'spread_stats', field: 'flash_major_version'}],
          ['Screen Size', :spread, {controller: 'gricer/sessions', action: 'spread_stats', field: 'screen_size'}],
          ['Color Depth', :spread, {controller: 'gricer/sessions', action: 'spread_stats', field: 'screen_depth'}]
        ] ]
      ]
    end
    
    # Configure page urls matching this Expression to be excluded from being tracked in Gricer statistics
    # Default is to exclude the admin pages
    # @return [Regexp] 
    def exclude_paths 
      @exclude_actions ||= /^#{admin_prefix}$/
    end
    
    # Configure the data file used by GeoIP
    # If you configure #geoip_db this property will be ignored.
    #
    # Default is no data file given.
    # @return [String] 
    def geoip_dat 
      @geoip_dat
    end
    
    # Configure the database instance used by GeoIP
    #
    # Default is none GeoIP database configured
    # @return [GeoIP::City]
    def geoip_db 
      @geoip_db ||= geoip_dat ? GeoIP::City.new(geoip_dat, :index, false) : nil
    end
    
    # Configure after which time of inactivity the Gricer::Session should expire
    #
    # Default is 15 minutes 
    # @return [Integer] 
    def max_session_duration 
      @max_session_duration ||= 15.minutes
    end
  
  end
end