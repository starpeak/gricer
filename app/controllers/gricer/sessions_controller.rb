module Gricer
  # This controller handles the session based statistics
  class SessionsController < BaseController
    private
    # Set the basic collection to sessions from browsers.
    def basic_collection
      ::Gricer.config.session_model.browsers
    end
    
    # Offer links to further details on some attributes
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