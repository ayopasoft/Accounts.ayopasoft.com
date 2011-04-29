require 'simple_record'
require 'digest/sha1'

class Admin < SimpleRecord::Base
  include Alias::Legacy
  
  set_domain_name 'ayopa-admins'
  has_attributes 'admin_email','admin_password','salt','reset_code','admin_inactive','admin_name'
   
  alias_column 'email' => 'admin_email'
  
  attr_accessor :type
  attr_accessor :password_confirmation
  
  def self.authenticate(email, password)
    user = self.find(:first, :conditions => ["`admin_email` = ?", email])
    puts("email: " + email)
    if user
      expected_password = Admin.encrypted_password(password, user.salt)
      puts("expected password:" + expected_password)
      if user.admin_password != expected_password
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
    self.admin_password = Admin.encrypted_password(self.password, self.salt)
  end
    
  def set_password (password, password_confirmation)
    errors.add('Passwords', 'do not match') unless password_confirmation == password
    #create_new_salt
    #hashed_password = Admin.encrypted_password(password, self.salt)
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
    self.save
  end
  
  def self.encrypted_password(password, salt)
    string_to_hash = password + "groupbuy" + salt
    string_to_hash = password
    Digest::SHA1.hexdigest(string_to_hash)
    
  end
  
end
