class User 
  def id
    42
  end
end

class ApplicationController < ActionController::Base
  protect_from_forgery
  
  gricer_track_requests
  
  def gricer_user_id   
    current_user.try(:id)
  end
  
  private
  def current_user
    User.new
  end
  
  
  
end
