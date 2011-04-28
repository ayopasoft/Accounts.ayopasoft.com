require 'simple_record'

class Auction < SimpleRecord::Base
  
  set_domain_name 'ayopa-auctions'
  has_attributes 'auction_end', 'auction_start', 'auction_id', 'auction_maxunits', 'auction_priceconflict', 'auction_schedule', \
                 'auction_startprice', 'merchant_id', 'merchant_name', 'merchant_website', 'product_cat', 'product_descr', 'product_id', \
                 'product_img_url', 'product_name', 'product_url'
  
  
end
