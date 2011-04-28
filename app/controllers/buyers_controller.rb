require 'net/http'
require 'json'
require 'time'

class BuyersController < ApplicationController
  layout 'template'
  before_filter :buyer_authorize
  
  def index
    @buyer = Buyer.find_by_id(session[:user_id])
    
    @purchases = Purchase.find(:all, :conditions => ["`purchase_buyer_id` = ?", @buyer.buyer_id], :order => "purchase_date desc")
    
    @purchases.each do |p|
      url = URI.parse('http://ayopa1dev.happyjacksoftware.com:8080/AyopaServer/current-auction-info')
      post_args1 = {'auctionID' => p.purchase_auction_id}
      resp, data = Net::HTTP.post_form(url, post_args1)
      result = JSON.parse(data)
      
      p.current_price = result['current_price']  
      p.current_level = result['current_level']
      p.next_price = result['next_price']
      p.next_level = result['next_level']
      p.lowest_price = result['lowest_price']
      p.lowest_level = result['lowest_level']
      
      p.savings = p.purchase_price.to_f - p.current_price.to_f
      
      @auction = Auction.find_by_auction_id(p.purchase_auction_id)
      
      
      p.merchant_name = @auction.merchant_name
      p.product_name = @auction.product_name
      
      if @auction.auction_end < Time.now.iso8601 
        p.auction_expired = 1
      end
      
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @consumers }
    end
  end
  
  def update
    @buyer = Buyer.find(session[:user_id])

    respond_to do |format|
      if @buyer.update_attributes(params[:buyer])
        format.html { redirect_to(:controller => 'buyers', :action => 'index', :notice => 'Buyer was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @buyer.errors, :status => :unprocessable_entity }
      end
    end
  end
  
end
