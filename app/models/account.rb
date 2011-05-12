class Account < ActiveRecord::Base
    attr_accessor :first_name, :last_name, :user_email, :user_password, :user_password_confirmation, :terms, :partner, \
                  :paypal, :website, :company_name
    validates_presence_of :first_name, :last_name, :user_email, :user_password, :user_password_confirmation, :terms
    validates_format_of       :user_email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/
    validates_format_of       :paypal, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/, :allow_blank => true
    validates_format_of       :website, :with => URI::regexp(%w(http https)), :allow_blank => true

    validates_confirmation_of :user_password
    validate :unique_email
    validate :terms_accepted
    validate :paypal_for_partner
    

protected
def unique_email
  user = Merchant.find(:first, :conditions => ["`merchant_email` = ?", self.user_email])
  errors.add(:user_email, "has already been registered with ayopa") unless user.nil?
end

def terms_accepted
  errors.add("Terms of Service", "must be accepted") unless self.terms == "1"
end
 
def paypal_for_partner
  if self.partner == "1" && self.paypal.blank?
    errors.add(:paypal, "account must be provided for merchant partners") 
  end
  errors.add(:website, "cannot be blank for merchant partners") if self.partner == "1" && self.website.blank?
  errors.add(:company_name, "cannot be blank for merchant partners") if self.partner == "1" && self.company_name.blank?
end
  
  
end
