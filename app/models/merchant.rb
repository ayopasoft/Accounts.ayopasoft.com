require 'simple_record'
require 'digest/sha1'

class Merchant < SimpleRecord::Base
  include Alias::Legacy
  
  set_domain_name 'ayopa-merchants'
  has_attributes 'merchant_username', 'merchant_password', 'merchant_fb_page', 'merchant_email', \
  'reset_code','merchant_salt','merchant_contact','merchant_name','merchant_paypal','merchant_address1', \
  'merchant_address2', 'merchant_city', 'merchant_state', 'merchant_postalcode', 'merchant_website', \
  'merchant_country', 'merchant_id', 'merchant_inactive'
  
  attr_accessor :password_confirmation
 
  alias_column 'email' => 'merchant_email'
  alias_column 'salt' => 'merchant_salt'
  
  attr_accessor :type
  
  def self.authenticate(email, password)
    user = self.find(:first, :conditions => ["`merchant_email` = ?", email])
    puts("email: " + email)
    if user
      expected_password = Merchant.encrypted_password(password, user.salt)
      puts("expected password:" + expected_password)
      if user.merchant_password != expected_password
        user = nil
      end      
    end
    user
  end
  
   def password
    @password
  end
  
  def password=(pwd)
    @password = pwd
    return if pwd.blank?
    create_new_salt
    self.merchant_password = Merchant.encrypted_password(self.password, self.salt)
  end
  
  def inactivate
    self.merchant_inactive = "1"
    self.save
  end
  
  def activate
    self.merchant_inactive = "0"
    self.save
  end
  
  def save_account (account)
    self.merchant_contact = account[:first_name] + " " + account[:last_name]
    create_new_salt
    hashed_password = Merchant.encrypted_password(account[:user_password], self.salt)
    self.merchant_password = hashed_password
    self.email = account[:user_email]
    self.merchant_paypal = account[:paypal]
    self.merchant_name = account[:company_name]
    self.merchant_website = account[:website]
    self.save
  end
    
  def set_password (password, password_confirmation)
    errors.add('Passwords', 'do not match') unless password_confirmation == password
    create_new_salt
    #hashed_password = Merchant.encrypted_password(password, self.salt)
    #self.password = hashed_password
    self.password = password
    self.save
  end
  
  def set_reset_code
    self.reset_code = (Array.new(15) { (rand(122-97) + 97).chr }.join)
    self.save
    return self.reset_code
  end
  
  def delete_reset_code
    self.reset_code = nil
    self.save
  end
  
private
  
  def password_non_blank
    errors.add(:password, "Missing password") if password.blank?
  end
  
  def create_new_salt
    self.salt = self.object_id.to_s + rand.to_s
    #self.save
  end
  
  def self.encrypted_password(password, salt)
    #string_to_hash = password + "groupbuy" + salt
    string_to_hash = password
    Digest::SHA1.hexdigest(string_to_hash)
    
  end
  
end
