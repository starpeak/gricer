module Gricer
  class TrackRequestFilter
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
  
  module TrackHelper
    def gricer_track_tag
      if gricer_request and defined?(gricer_capture_path)
        content_tag :script, "jQuery(function($) {$.post('#{gricer_capture_path(gricer_request.id)}', Gricer.prepareValues());});", type: 'text/javascript'
      end
    end
  end
  
  module ActionController
    module Tracker
      def self.included(base)
        base.append_around_filter TrackRequestFilter
        base.helper TrackHelper
        base.helper_method :gricer_request
      end
      
      def gricer_request=(gricer_request)
        @gricer_request = gricer_request
      end
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