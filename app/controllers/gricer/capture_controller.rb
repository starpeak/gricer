module Gricer
  # This is the controller to capture additional values from the Javascript track tag.
  #
  # @see Gricer::TrackHelper#gricer_track_tag
  class CaptureController < ::ApplicationController  
    # This action stores the data submitted by the Javascript.
    def index
      gricer_request = ::Gricer.config.request_model.find_by_id(params[:id]) 
      gricer_session = ::Gricer.config.session_model.find_by_id(session[:gricer_session])   
      
      if gricer_session
        gricer_session.javascript          = true
        gricer_session.java                = params[:j]
        gricer_session.flash_version       = params[:f] unless params[:f] == 'false'
        gricer_session.silverlight_version = params[:sl] unless params[:sl] == 'false'
        gricer_session.screen_width        = params[:sx]
        gricer_session.screen_height       = params[:sy]
        gricer_session.screen_size         = "#{params[:sx]}x#{params[:sy]}" unless params[:sx].blank? or params[:sy].blank?
        gricer_session.screen_depth        = params[:sd] 
        gricer_session.save
       
        if gricer_request and gricer_request.session == gricer_session
              
          gricer_request.javascript          = true
          gricer_request.window_width        = params[:wx]
          gricer_request.window_height       = params[:wy]
      
          if gricer_request.save
            render text: 'ok'
          else
            render text: 'session only', status: 500
          end
          return
        else
          render text: 'session only'
          return
        end
      end
      render text: 'failed', status: 500
    end
  end
end