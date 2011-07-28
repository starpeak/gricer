module Gricer
  class DashboardController < BaseController      
    def index
      @sessions = Session.browsers.between_dates(@stat_from, @stat_thru)
      @requests = Request.browsers.between_dates(@stat_from, @stat_thru)
    end
    
    def overview
      @sessions = Session.browsers.between_dates(@stat_from, @stat_thru)
      @requests = Request.browsers.between_dates(@stat_from, @stat_thru)
      
      render partial: 'overview.html', locals: {sessions: @sessions, requests: @requests}
    end
  end
end