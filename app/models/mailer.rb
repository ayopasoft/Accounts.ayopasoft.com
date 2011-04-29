class Mailer < ActionMailer::Base
  
  def forgot_password reset_code, user, reset_url
      @subject = "Link to reset your password"
      @body = { :user => user, :reset_url => reset_url }
      @recipients = user.email
      @from = "info@ayopasoft.com"
      @sent_on = Time.now
  end
  
  def new_admin_account reset_code, user, reset_url
    @subject = "Ayopa admin account created for you"
      @body = { :user => user, :reset_url => reset_url }
      @recipients = user.email
      @from = "info@ayopasoft.com"
      @sent_on = Time.now
  end
  
  def new_merchant_account reset_code, user, reset_url
    @subject = "Your Ayopa Account"
      @body = { :user => user, :reset_url => reset_url }
      @recipients = user.email
      @from = "info@ayopasoft.com"
      @sent_on = Time.now
  end
  
end
