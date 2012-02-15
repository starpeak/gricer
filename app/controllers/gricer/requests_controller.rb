module Gricer
  # This controller handles the request based statistics
  class RequestsController < BaseController    

    private
    # Set the basic collection to requests from browsers.
    def basic_collection
      ::Gricer.config.request_model.browsers
    end
    
    # Handle special fields
    def handle_special_fields
      if ['referer_host', 'referer_path', 'referer_params', 'search_engine', 'search_query'].include?(params[:field])
        @items = @items.only_first_in_session
      end
      
      if ['search_engine', 'search_query'].include?(params[:field])
        @items = @items.without_nil_in params[:field]
      end
      
      if params[:field] == 'entry_path'
        params[:field] = 'path'
        @items = @items.only_first_in_session
      end
      
      super
    end
    
    # Offer links to further details on some attributes
    def further_details 
      {
        'referer_host' => 'referer_path',
        'referer_path' => 'referer_params',
      
        'agent.name' => 'agent.major_version',
        'agent.os' => 'agent.name',
        'agent.major_version' => 'agent.full_version',
        'agent.engine_name' => 'agent.engine_version',          
      }
    end
  end
end