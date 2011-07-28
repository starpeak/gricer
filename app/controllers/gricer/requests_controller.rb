module Gricer
  class RequestsController < BaseController    

    private
    def basic_collection
      Request.browsers
    end
    
    def handle_special_fields
      if ['referer_host', 'referer_path', 'referer_params', 'search_engine', 'search_query'].include?(params[:field])
        @items = @items.only_first_in_session
      end
      
      if ['search_engine', 'search_query'].include?(params[:field])
        @items = @items.where("#{params[:field]} IS NOT NULL")
      end
      
      if params[:field] == 'entry_path'
        params[:field] = 'path'
        @items = @items.only_first_in_session
      end
      
      super
    end
    
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