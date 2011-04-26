 class Login < ActiveRecord::Base
   attr_accessor :first_name, :last_name, :user_email, :user_password, :user_password_confirmation, :terms
   attr_accessible :first_name, :last_name, :user_email, :user_password, :user_password_confirmation, :terms
    validates_presence_of :first_name, :last_name, :user_email, :user_password, :user_password_confirmation, :terms
    validates_confirmation_of :password
    
    def validate
      errors.add(:first_name, 'must not be blank') if first_name.blank?
      errors.add(:terms, 'must not be blank') if terms.blank?
      errors.add('Passwords', 'do not match') unless user_password_confirmation == user_password
  end

  def first_name
    @first_name
  end
  
  def first_name=(name)
    self.first_name = name
  end
  
 end
