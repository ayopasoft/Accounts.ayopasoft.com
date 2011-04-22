require 'simple_record'

 class Login < SimpleRecord::Base
    has_attributes :buyer_email
 end
