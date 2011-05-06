require 'simple_record'
require 'digest/sha1'


class Buyer < SimpleRecord::Base
  include Alias::Legacy
  
  set_domain_name 'ayopa-buyers'
  has_attributes 'buyer_id','buyer_email', 'buyer_name', 'buyer_address1', 'buyer_address2','buyer_city', \
                 'buyer_state', 'buyer_zip', 'buyer_country', 'buyer_password', 'buyer_salt', 'reset_code', \
                 'buyer_paypal'
  
  alias_column 'email' => 'buyer_email'
   alias_column 'salt' => 'buyer_salt'
  
  
  attr_accessor :password_confirmation
  attr_accessor :type
  
  def self.authenticate(email, password)
    user = self.find(:first, :conditions => ["`buyer_email` = ?", email])
    if user
      expected_password = encrypted_password(password, user.buyer_salt)
      
      if user.buyer_password != expected_password
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
    self.buyer_password = Buyer.encrypted_password(self.password, self.salt)
  end
  
  def save_account (account)
    name = account[:first_name] + " " + account[:last_name]
    self.buyer_name = name
    create_new_salt
    hashed_password = Buyer.encrypted_password(account[:user_password], self.salt)
    self.buyer_password = hashed_password
    self.email = account[:user_email]
    self.save
  end
  
  def set_password (password, password_confirmation)
    #errors.add('Passwords', 'do not match') unless password_confirmation == password
    #create_new_salt
    #hashed_password = Buyer.encrypted_password(password, self.buyer_salt)
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
    errors.add(:password, "Missing password") if buyer_password.blank?
  end
  
  def create_new_salt
    self.buyer_salt = self.object_id.to_s + rand.to_s
    #self.save
  end
  
  def self.encrypted_password(password, salt)
    string_to_hash = password + "groupbuy" + salt
    Digest::SHA1.hexdigest(string_to_hash)
  end
    
end
