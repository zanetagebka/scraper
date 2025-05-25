class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  
  private
  
  def json_request?
    request.format.json?
  end
end
