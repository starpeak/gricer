class DashboardController < ApplicationController
  
  helper Gricer::BaseHelper
  
  def index
  end

  def error
    this_function_does_not_exist
  end

  def forbidden
    render text: 'Forbidden', status: 403 
  end

  def redirect
    redirect_to '/'
  end
end
