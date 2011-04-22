require 'simple_record'

class Buyer < SimpleRecord::Base
  has_attributes :buyer_email
end
