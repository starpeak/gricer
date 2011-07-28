module Gricer
  module BaseHelper
    def format_percentage value
      '%3.2f %' % (value * 100)
    end
    
    def format_seconds value
      '%02d:%02d:%02d' % [(value/3600).floor,((value/60)%60).floor,(value%60)]
    end
  end
end
