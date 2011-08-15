module Gricer
  # A helper with some basic features for formating Gricer's data
  module BaseHelper
    # Format a value as percentage
    # @example
    #   ruby> format_percentage 0.4223
    #
    #   => "42.23 %"
    def format_percentage value
      '%3.2f %' % (value * 100)
    end
    
    # Format a value of seconds as time range
    # @example
    #   ruby> format_seconds 102
    #
    #   => "00:01:42"
    def format_seconds value
      '%02d:%02d:%02d' % [(value/3600).floor,((value/60)%60).floor,(value%60)]
    end
  end
end
