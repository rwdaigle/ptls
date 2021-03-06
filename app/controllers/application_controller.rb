require 'authenticated_system'

class ApplicationController < ActionController::Base

  # Standard configs
  helper :all
  include AuthenticatedSystem
  protect_from_forgery
  
  # Most everything requires a logged in user
  before_filter :login_required
  before_filter :set_user_time_zone
  
  # Assume we want the subject-relevant layout unless told otherwise
  layout 'subject'

  def controller
    @controller
  end
  
  private

  # User-specific time zones
  def set_user_time_zone
    Time.zone = current_user.time_zone if logged_in?
  end
end
