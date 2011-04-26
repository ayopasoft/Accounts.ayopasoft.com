class LoginController < ApplicationController
  layout 'login'
  
    
  def login
    if request.post?
      user = User.authenticate(params[:userName], params[:password])
      if user
          if user.type == "buyer" 
            redirect_to(:controller => 'pages', :action => 'consumer_home', :id => user.id)
          elsif user.type == "merchant"
             redirect_to(:controller => 'pages', :action => 'merchant_home', :id => user.id)
          elsif user.type == "admin"
             redirect_to(:controller => 'pages', :action => 'admin_home', :id => user.id)
          else
            redirect_to(:controller => 'pages', :action => 'consumer_home', :id => user.id)
          end
      else
        flash.now[:alert] = "Invalid user/password combination"
      end
    end
 end

def forgot_password
    if request.post?
      user = User.lookup_by_email( params[:email])
      if user.nil?
        flash[:alert] = "No such user"
      else
        
        reset_code = user.set_reset_code
     
        Mailer.deliver_forgot_password reset_code, user, (reset_password_url :reset_code => reset_code)
        flash[:alert] = "Reset code sent to #{user.email}"
        redirect_to :controller => 'login', :action => 'login'
      end
    end
  end
  
  def reset_password
    flash[:alert] = nil
    @user = User.reset_user(params[:reset_code]) unless params[:reset_code].nil?
    if @user.nil?
      flash[:alert] = "One-time use password reset link was already used."
      redirect_to :controller => 'login', :action => 'login'
    else
      if request.post?
        if params[:password].blank?
          flash.now[:alert] = "You must enter a new password"
          render :action => :reset_password
        elsif params[:password] != params[:password_confirmation]
          flash.now[:alert] = "Passwords do no match"
          render :action => :reset_password
        else
          if @user.set_password(params[:password], params[:password_confirmation])
            
            @user.delete_reset_code
            flash[:alert] = "Password reset successfully for #{@user.email}"

            redirect_to :controller => 'login', :action => 'login'
          else
            render :action => :reset_password
          end
        end
      end
    end
  end
  
 
  
end
