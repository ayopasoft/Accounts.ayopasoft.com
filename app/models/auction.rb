require 'simple_record'

class Auction < SimpleRecord::Base
  
  set_domain_name 'ayopa-auctions'
  has_attributes 'auction_end', 'auction_start', 'auction_id', 'auction_maxunits', 'auction_priceconflict', 'auction_schedule', \
                 'auction_startprice', 'merchant_id', 'merchant_name', 'merchant_website', 'product_cat', 'product_descr', 'product_id', \
                 'product_img_url', 'product_name', 'product_url', 'auction_deleted', 'rebate_sent'
  
  attr_accessor :current_price, :current_level, :current_rebate, :next_price, :next_level, :lowest_price, :lowest_level, :auction_expired, \
                :rebate_total, :commission_total, :auction_total
  
  
end
