# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  
  #before_filter :authorize, :except => :login
  after_filter :close_sdb_connection
  

  def close_sdb_connection
    SimpleRecord.close_connection
  end
  
 protected
  
  def authorize
    unless User.find_by_id(session[:user_id])
      flash[:notice] = "Please Log In"
      redirect_to :controller => 'login', :action => 'login'
    end
  end
  
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
end
