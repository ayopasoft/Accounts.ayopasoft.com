require 'simple_record'

class Purchase < SimpleRecord::Base
  set_domain_name 'ayopa-purchases'
  has_attributes 'auction_end', 'auction_start', 'purchase_auction_id', 'purchase_buyer_id', \
                 'purchase_date', 'purchase_id', 'purchase_price', 'purchase_quantity', 'rebate_sent'
  attr_accessor :merchant_name, :product_name, :current_price, :current_level, :next_price, :next_level, \
                :lowest_price, :lowest_level, :auction_expired, :auction_deleted, :savings
  
end
