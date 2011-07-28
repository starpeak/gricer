module Gricer
  class Config
    attr_writer :table_name_prefix, :admin_prefix, :admin_layout # :nodoc:
    attr_writer :geoip_db, :geoip_dat # :nodoc:
    attr_writer :exclude_paths # :nodoc:
    attr_writer :admin_menu #:nodoc:
    
    def initialize(&block) #:nodoc:
      configure(&block) if block_given?
    end

    # Configure your Gricer Rails Engine with the given parameters in 
    # the block. For possible options see above.
    def configure(&block)
      yield(self)
    end
    
    def table_name_prefix #:nodoc:
      @table_name_prefix ||= 'gricer_'
    end
    
    def admin_prefix #:nodoc:
      @admin_prefix.blank? ? 'gricer' : @admin_prefix
    end
    
    def admin_layout #:nodoc:
      @admin_layout
    end
    
    def admin_menu #:nodoc:
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
    
    def exclude_paths #:nodoc:
      @exclude_actions ||= /^#{admin_prefix}$/
    end
    
    def geoip_dat #:nodoc:
      @geoip_dat
    end
    
    def geoip_db #:nodoc:
      @geoip_db ||= geoip_dat ? GeoIP::City.new(geoip_dat, :index, false) : nil
    end
    
    def max_session_duration #:nodoc:
      @max_session_duration ||= 15.minutes
    end
  
  end
end