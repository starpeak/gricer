module Gricer
  # Around-Filter for tracking requests in Gricer
  class TrackRequestFilter
    # Around-Filter for tracking requests in Gricer
    # @param controller The controller from which this Filter was included.
    # @yield The controller's code block
    def self.filter(controller, &block)
      if controller.controller_path =~ /^gricer\// or controller.request.path =~ ::Gricer.config.exclude_paths
        Rails.logger.debug "Gricer Track Request: Do not track '#{controller.controller_path}##{controller.action_name}' by config"
        block.call
        return
      end
      
      status = nil
      
      options = {
        request: controller.request, 
        controller: controller.controller_path,
        action: controller.action_name,
        params: controller.params,
        session_id: controller.session[:gricer_session],
        locale: I18n.locale
      }

      if controller.gricer_user_id
        options[:user_id] = controller.gricer_user_id
      end
      
      options.keys.each do |key|
        Rails.logger.debug key
      end
      
      gricer_request = ::Gricer::Request.create options
      controller.gricer_request = gricer_request
      controller.session[:gricer_session] = gricer_request.session_id
        
      begin
        benchmark = Benchmark.measure(&block)
        
        gricer_request.update_attributes(
          status_code: controller.response.status,
          content_type: controller.response.content_type,
          body_size: controller.response.body.size,
          system_time: (benchmark.cstime*1000).to_i,
          user_time: (benchmark.cutime*1000).to_i,
          total_time: (benchmark.total*1000).to_i,
          real_time: (benchmark.real*1000).to_i
        )
      rescue 
        gricer_request.update_attributes(
          status_code: 500,
          content_type: controller.response.content_type,
          body_size: controller.response.body.size
        )
        raise
      end
    end
  end 
  
  # Helper Method to include Javascript code to capture extra values like screen size
  module TrackHelper
    # Include Gricer's Javascript code to track values like screen size. 
    #
    # You should include this at the end of your layout file. For pages matching the
    # Gricer::Config.exclude_paths expression, nothing will be added to your page.
    #
    # @example For html.erb add at the end of your layout file:
    #  <html>
    #    <head>[...]</head>
    #    <body>
    #       [...]
    #       <%= gricer_track_tag %>
    #     </body>
    #   </html>
    #
    # @example For html.haml add at the end of your layout file:
    #  %html
    #    %head
    #      [...]
    #    %body
    #      [...]
    #      = gricer_track_tag 
    
    def gricer_track_tag
      if gricer_request and defined?(gricer_capture_path)
        content_tag :script, "jQuery(function($) {$.post('#{gricer_capture_path(gricer_request.id)}', Gricer.prepareValues());});", type: 'text/javascript'
      end
    end
  end
  
  module ActionController
    # Gricer's Tracker module for ActionController
    #
    # To include the Tracker module into ActionController add
    # gricer_track_requests to your ApplicationController or
    # to any Controller you want to track with Gricer.
    #
    # @example 
    #   class ApplicationController < ActionController::Base
    #     protect_from_forgery
    #     gricer_track_requests
    #     [...]
    #   end
    
    module Tracker
      # Include the helper functions and around_filter into controllers.
      def self.included(base)
        base.append_around_filter TrackRequestFilter
        base.helper TrackHelper
        base.helper_method :gricer_request
      end
      
      # Set the actual gricer request instance.
      # @param gricer_request [Gricer::Request] The gricer request to be set as actual request instance.
      def gricer_request=(gricer_request)
        @gricer_request = gricer_request
      end
      
      # Get the actual gricer request instance.
      # @return [Gricer::Request]
      def gricer_request
        @gricer_request
      end
    end
  end
end

class ActionController::Base
  def self.gricer_track_requests(options = {})
    include Gricer::ActionController::Tracker
  end
end