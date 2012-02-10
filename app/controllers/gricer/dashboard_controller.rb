module Gricer
  # This controller contains the dashboard for the administration view
  class DashboardController < BaseController      
    # This action renders the frame for the statistics tool
    def index
      @sessions = Session.browsers.between_dates(@stat_from, @stat_thru)
      @requests = Request.browsers.between_dates(@stat_from, @stat_thru)
    end
    
    # This action renderes the overview of some data in the statistics tool
    def overview
      @sessions = Session.browsers.between_dates(@stat_from, @stat_thru)
      @requests = Request.browsers.between_dates(@stat_from, @stat_thru)
      
      render partial: 'overview', formats: [:html], locals: {sessions: @sessions, requests: @requests}
    end
  end
end