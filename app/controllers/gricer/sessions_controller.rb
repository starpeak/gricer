module Gricer
  class SessionsController < BaseController
    private
    def basic_collection
      Session.browsers
    end
    
    def further_details 
      {
        'agent.name' => 'agent.major_version',
        'agent.os' => 'agent.name',
        'agent.major_version' => 'agent.full_version',
        'agent.engine_name' => 'agent.engine_version',
        'silverlight_major_version' => 'silverlight_version',
        'flash_major_version' => 'flash_version',
        'country' => 'city',
        'requested_locale_major' => 'requested_locale_minor',
      }
    end
  end
end