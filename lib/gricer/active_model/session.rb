module Gricer
  # Gricer's ActiveModel enhancements
  module ActiveModel
    module Session
      
      # Extend the ActiveModel with the statistics class methods.
      # @see ClassMethods
      def self.included(base)
        base.extend ClassMethods
      end
      
      module ClassMethods
        # Filter out only bounce sessions (sessions with just one request)
        # @return [ActiveRecord::Relation/Mongoid::Criteria]
        def bounce_sessions
          self.where(requests_count: 1)
        end

        # Filter out only new visits (which does not have a previous_session)
        # @return [ActiveRecord::Relation/Mongoid::Criteria]
        def new_visits
          self.where(previous_session_id: nil)
        end

        # Get the bounce rate 
        #
        # This is the rate of sessions with one request to sessions with multiple requests.
        # @return [Float]
        def bounce_rate
          if (c = self.count) > 0
            self.bounce_sessions.count / c.to_f
          else
            0
          end
        end

        # Get the average count of requests per session.
        #
        # @return [Float]
        def requests_per_session
          if (c = self.count) > 0
            self.sum(:requests_count) / c.to_f
          else
            0
          end
        end
        
        # Get the new visitor rate
        #
        # This is the rate of new sessions to all sessions
        # return [Float]
        def new_visitors
          if (c = self.count) > 0
            self.new_visits.count / c.to_f
          else
            0
          end
        end
        
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
    
    

      
      # Get the duration of the current session instance
      def duration
        updated_at - created_at
      end
    
      
    end
  end
end