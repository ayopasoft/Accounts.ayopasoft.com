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
      url = URI.parse('http://beta.ayopasoft.com/AyopaServer/current-auction-info')
      post_args1 = {'auctionID' => p.purchase_auction_id}
      resp, data = Net::HTTP.post_form(url, post_args1)
      result = JSON.parse(data)
      
      p.current_price = result['current_price']  
      p.current_level = result['current_level']
      p.next_price = result['next_price']
      p.next_level = result['next_level']
      p.lowest_price = result['lowest_price']
      p.lowest_level = result['lowest_level']
      
      p.savings = (p.purchase_price.to_f - p.current_price.to_f) * p.purchase_quantity.to_f
      
      @auction = Auction.find_by_auction_id(p.purchase_auction_id)
      
      
      p.merchant_name = @auction.merchant_name
      p.product_name = @auction.product_name
      
      if @auction.auction_end < Time.now.iso8601 
        p.auction_expired = 1
      end
      
      if @auction.auction_deleted == "1"
        p.auction_deleted = 1
      end
      
    end
    
    #@purchases.delete_if {|p| p.auction_deleted == "1"}

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @consumers }
    end
  end
  
  def set_password
    if !params[:buyer][:password].blank? && !params[:buyer][:password_confirmation].blank? && params[:buyer][:password] == params[:buyer][:password_confirmation]
      user = Buyer.find(params[:buyer][:id])
      if user
        user.set_password(params[:buyer][:password], params[:buyer][:password_confirmation])
        flash[:alert] = "Password has been set"
      else
        flash[:alert] = "Password cannot be set at this time"
      end
    else
      flash[:alert] = "Password/Password confirmation blank or passwords do not match"
    end
    redirect_to :controller => "buyers", :action => "index"
  end
  
  def update
    @buyer = Buyer.find(session[:user_id])

    respond_to do |format|
      if @buyer.update_attributes(params[:buyer])
        format.html { redirect_to(:controller => 'buyers', :action => 'index') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @buyer.errors, :status => :unprocessable_entity }
      end
    end
  end
  
end
