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
  
  
  
  def buyer_authorize
    if ( cookies[:remember_me] and cookies[:remember_me] and Buyer.find( cookies[:remember_me]) and Digest::SHA1.hexdigest( Buyer.find( cookies[:remember_me] ).email )[4,18] == cookies[:remember_me_code]  )  
          @u = Buyer.find( cookies[:remember_me_id] )  
          session[:user_id] = @u.id
          session[:user_type] = "buyer"
          session[:user_name] = @u.buyer_name
      end  
    unless !session[:user_id].nil? && Buyer.find_by_id(session[:user_id])
      flash[:notice] = "Please Log In"
      redirect_to :controller => 'login', :action => 'login'
    end
  end
  
  def merchant_authorize
    if ( cookies[:remember_me] and cookies[:remember_me] and Merchant.find( cookies[:remember_me]) and Digest::SHA1.hexdigest( Merchant.find( cookies[:remember_me] ).email )[4,18] == cookies[:remember_me_code])  
          @u = Merchant.find( cookies[:remember_me_id] )  
          session[:user_id] = @u.id  
          session[:user_type] = "merchant"
          session[:user_name] = @u.merchant_name
      end  
    unless !session[:user_id].nil? && (Merchant.find_by_id(session[:user_id]) && Merchant.find(session[:user_id]).merchant_inactive != "1" || Admin.find_by_id(session[:user_id])) 
      flash[:notice] = "Please Log In"
      redirect_to :controller => 'login', :action => 'login'
    end
  end
  
  def admin_authorize
    if ( cookies[:remember_me] and cookies[:remember_me] and Admin.find( cookies[:remember_me]) and Digest::SHA1.hexdigest( Admin.find( cookies[:remember_me] ).email )[4,18] == cookies[:remember_me_code]  )  
          @u = Admin.find( cookies[:remember_me_id] )  
          session[:user_id] = @u.id  
          session[:user_type] = "admin"
          session[:user_name] = "ADMIN"
    end  
    unless !session[:user_id].nil? && Admin.find_by_id(session[:user_id]) && Admin.find(session[:user_id]).admin_inactive != "1"
      flash[:notice] = "Please Log In"
      redirect_to :controller => 'login', :action => 'login'
    end
  end
  
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
end
