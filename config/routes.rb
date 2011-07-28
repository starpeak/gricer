Rails.application.routes.draw do
  post 'gricer_capture/:id' => 'gricer/capture#index', as: :gricer_capture
  
  scope ::Gricer.config.admin_prefix do
    root to: "gricer/dashboard#index", as: :gricer_root
    post 'overview' => "gricer/dashboard#overview", as: :gricer_overview
    
    scope 'sessions' do
      [
        'agent.name', 'agent.os', 'agent.full_version', 'agent.major_version', 'agent.engine_name', 'agent.engine_version', 
        'javascript', 'java', 'silverlight_version', 'silverlight_major_version', 'flash_version', 'flash_major_version',
        'country', 'city', 'domain', 'screen_size', 'screen_width', 'screen_height', 'screen_depth',
        'requested_locale_major', 'requested_locale_minor', 'requested_locale', 
      ].each do |field|
        name = field.gsub('.', '_')
        get "#{name}_process" => "gricer/sessions#process_stats", field: field, as: "gricer_sessions_#{name}_process"
        get "#{name}_spread" => "gricer/sessions#spread_stats", field: field, as: "gricer_sessions_#{name}_spread"
      end
    end
    
    scope 'requests' do
      [
        'agent.name', 'agent.os', 'agent.full_version', 'agent.major_version', 'agent.engine_name', 'agent.engine_version', 
        'host', 'path', 'method', 'protocol', 'entry_path',
        'referer_protocol', 'referer_host', 'referer_path', 'referer_params',
        'search_engine', 'search_query',
      ].each do |field|
        name = field.gsub('.', '_')
        get "#{name}_process" => "gricer/requests#process_stats", field: field, as: "gricer_requests_#{name}_process"
        get "#{name}_spread" => "gricer/requests#spread_stats", field: field, as: "gricer_requests_#{name}_spread"
      end
    end
  end
end

# Gricer::Engine.routes.draw do
#   root to: "dashboard#index"
#   
#   scope 'sessions' do
#     [
#       'agent.name', 'agent.os', 'agent.full_version', 'agent.major_version', 'agent.engine_name', 'agent.engine_version', 
#       'javascript', 'java', 'silverlight_version', 'silverlight_major_version', 'flash_version', 'flash_major_version',
#       'country', 'city', 'domain', 'screen_size', 'screen_width', 'screen_height', 'screen_depth',
#       'requested_major_locale', 'requested_minor_locale', 'requested_locale', 
#     ].each do |field|
#       name = field.gsub('.', '_')
#       get "#{name}_process" => "sessions#process_stats", field: field, as: "gricer_session_#{name}_process"
#       get "#{name}_spread" => "sessions#spread_stats", field: field, as: "gricer_session_#{name}_spread"
#     end
#   end
# end