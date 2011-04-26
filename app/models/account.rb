class Account < ActiveRecord::Base
    attr_accessor :first_name, :last_name, :user_email, :user_password, :user_password_confirmation, :terms, :partner
    validates_presence_of :first_name, :last_name, :user_email, :user_password, :user_password_confirmation, :terms
    validates_format_of       :user_email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/
    validates_confirmation_of :user_password
    validate :unique_email
    validate :terms_accepted
    

protected
def unique_email
  user = User.lookup_by_email(self.user_email)
  errors.add(:user_email, "has already been registered with ayopa") unless user.nil?
end

def terms_accepted
  errors.add("Terms of Service", "must be accepted") unless self.terms == "1"
end
 
  
  
end
