module Gricer
  # ActiveRecord Model for Session Statistics
  # @attr [Gricer::Session] previous_session
  #   The current value of the associated previous session.
  #
  # @attr [Gricer::Agent] agent
  #   The current value of the associated agent.
  #
  # @attr [String] ip_address_hash
  #   The current value of the ip address in an anonyminized hash
  #
  # @attr [String] domain
  #   The current value of the domain (only major info) from which the session was requested.
  #
  # @attr [String] country
  #   The current value of the country from which the session was requested.
  #
  #   You need to configure a GeoIP in the {Gricer::Config} instance.
  #
  # @attr [String] region
  #   The current value of the region from which the session was requested.
  #
  #   You need to configure a GeoIP in the {Gricer::Config} instance.
  #
  # @attr [String] city
  #   The current value of the city from which the session was requested.
  #
  #   You need to configure a GeoIP in the {Gricer::Config} instance.
  #
  # @attr [String] postal_code
  #   The current value of the region from which the session was requested.
  #
  #   You need to configure a GeoIP in the {Gricer::Config} instance.
  #
  # @attr [Float] longitude
  #   The current value of the longitude of the city/region from which the session was requested.
  #
  #   You need to configure a GeoIP in the {Gricer::Config} instance.
  #
  # @attr [Float] latitude
  #   The current value of the latitude of the city/region from which the session was requested.
  #
  #   You need to configure a GeoIP in the {Gricer::Config} instance.
  #
  # @attr [Boolean] javascript
  #   The current value of the javascript capability of the requesting agent.
  #
  #   This feature needs the usage of {Gricer::TrackHelper#gricer_track_tag}.
  #
  # @attr [Boolean] java
  #   The current value of the java capability of the requesting agent.
  #
  #   This feature needs the usage of {Gricer::TrackHelper#gricer_track_tag}.
  #
  # @attr [String] flash_version
  #   The current value of the version of flash installed on the requesting agent.
  #
  #   This feature needs the usage of {Gricer::TrackHelper#gricer_track_tag}.
  #
  # @attr [String] flash_major_version
  #   The current value of the major version of flash installed on the requesting agent.
  #
  #   This feature needs the usage of {Gricer::TrackHelper#gricer_track_tag}.
  #
  # @attr [String] silverlight_version
  #   The current value of the version of silverlight installed on the requesting agent.
  #
  #   This feature needs the usage of {Gricer::TrackHelper#gricer_track_tag}.
  #
  # @attr [String] silverlight_major_version
  #   The current value of the major version of silverlight installed on the requesting agent.
  #
  #   This feature needs the usage of {Gricer::TrackHelper#gricer_track_tag}.
  #
  # @attr [Integer] screen_width
  #   The current value of the width in pixels of the screen the requesting agent's window is on.
  #
  #   This feature needs the usage of {Gricer::TrackHelper#gricer_track_tag}.
  #
  # @attr [Integer] screen_height
  #   The current value of the height in pixels of the screen the requesting agent's window is on.
  #
  #   This feature needs the usage of {Gricer::TrackHelper#gricer_track_tag}.
  #
  # @attr [Integer] screen_depth
  #   The current value of the depth in bits of the screen the requesting agent's window is on.
  #
  #   This feature needs the usage of {Gricer::TrackHelper#gricer_track_tag}.
  #
  # @attr [String] requested_locale_major
  #   The current value of the locale requested (major locale only)
  #
  # @attr [String] requested_locale_minor
  #   The current value of the locale requested (major locale only)
  #
  # @attr [String] requested_locale
  #   The current value of the locale requested 
  #
  class Session < ::ActiveRecord::Base
    self.table_name = "#{::Gricer::config.table_name_prefix}sessions"
    include ActiveModel::Statistics
    
    has_many :requests, class_name: 'Gricer::Request', foreign_key: :session_id, order: 'created_at ASC'
    belongs_to :agent, class_name: 'Gricer::Agent', foreign_key: :agent_id, counter_cache: true
    belongs_to :previous_session, class_name: 'Gricer::Session', foreign_key: :previous_session_id
    
    # Filter out anything that is not a Browser or MobileBrowser
    # @return [ActiveRecord::Relation]
    def self.browsers
      self.includes("agent")
      .where("\"#{Agent.table_name}\".\"agent_class_id\" IN (?)", [0x1000, 0x2000])
    end
    
    # Filter out only bounce sessions (sessions with just one request)
    # @return [ActiveRecord::Relation]
    def self.bounce_sessions
      self.where("\"#{self.table_name}\".\"requests_count\" = ?", 1)
    end
    
    # Filter out only new visits (which does not have a previous_session)
    # @return [ActiveRecord::Relation]
    def self.new_visits
      where("\"#{self.table_name}\".\"previous_session_id\" IS NULL")
    end
    
    def ip_address=(ip)
      self.attributes = Gricer::Parsers::Ip.get_info(ip)
    end
    
    def requested_locale=(locale)
      self.requested_locale_major, self.requested_locale_minor = locale.try(:downcase).try(:split, '-')
    end
    
    def requested_locale
      if requested_locale_minor
        "#{requested_locale_major}-#{requested_locale_minor}"
      else
        requested_locale_major
      end
    end
    
    def silverlight_version=(version)
      self[:silverlight_version] = version
      self.silverlight_major_version = silverlight_version.match(/^([0-9]*\.[0-9]*)/).to_a.last if silverlight_version
    end
    
    def flash_version=(version)
      self[:flash_version] = version
      self.flash_major_version = flash_version.match(/^([0-9]*\.[0-9]*)/).to_a.last if flash_version
    end
    
    # Get the bounce rate 
    #
    # This is the rate of sessions with one request to sessions with multiple requests.
    # @return [Float]
    def self.bounce_rate
      if (c = self.count) > 0
        self.bounce_sessions.count / c.to_f
      else
        0
      end
    end
    
    # Get the average count of requests per session.
    #
    # @return [Float]
    def self.requests_per_session
      if (c = self.count) > 0
        self.sum(:requests_count) / c.to_f
      else
        0
      end
    end
    
    # Get the average duration of sessions in seconds.
    #
    # @return [Float]
    def self.avg_duration
      if (c = self.count) > 0
        #logger.debug ActiveRecord::Base.connection.class
        
        if ActiveRecord::Base.connection.class.to_s == 'ActiveRecord::ConnectionAdapters::PostgreSQLAdapter'
          self.sum("date_part('epoch', \"#{self.table_name}\".\"updated_at\") - date_part('epoch', \"#{self.table_name}\".\"created_at\")").to_f / c.to_f    
        else
          self.sum("strftime('%s', \"#{self.table_name}\".\"updated_at\") - strftime('%s', \"#{self.table_name}\".\"created_at\")") / c.to_f
        end
      else
        0
      end
    end
    
    # Get the duration of the current session instance
    def duration
      updated_at - created_at
    end
    
    # Get the new visitor rate
    #
    # This is the rate of new sessions to all sessions
    # return [Float]
    def self.new_visitors
      if (c = self.count) > 0
        self.new_visits.count / c.to_f
      else
        0
      end
    end
  end
end