class User < ActiveRecord::Base
  
  validates_presence_of :username
  validates_uniqueness_of :username
  
  attr_accessor :password_confirmation
  validates_confirmation_of :password
  
  def self.authenticate(email, password)
     user = Admin.authenticate(email, password)
     if user
       user.type = "admin"
     else
       user = Merchant.authenticate(email, password)
       if user
         user.type = "merchant"
       else
         user = Buyer.authenticate(email, password)
         if user
           user.type = "buyer"
       end
      end
   end
   user
 end
 
 def self.lookup_by_email(email)
     user = Admin.find(:first, :conditions => ['`admin_email` = ?', email])
     if user
       user.type= "admin"
     else
         user = Buyer.find(:first, :conditions => ['`buyer_email` = ?', email])
         if user
           user.type = "buyer"
         else
           user = Merchant.find(:first, :conditions => ['`merchant_email` = ?', email])
           if user
             user.type = "merchant"
           end
        end
   end
   user
 end
 
  def self.reset_user(reset_code)
    user = Admin.find_by_reset_code(reset_code)
    if user
      user.type = "admin"
    else
     user = Buyer.find(:first, :conditions => ['`reset_code` = ?', reset_code])
     if user
       user.type = "buyer"
     else
       user = Merchant.find(:first, :conditions => ['`reset_code` = ?', reset_code])
       if user
         user.type = "merchant"
       end
   end
   end
   user
  end
   
end
