require 'time'

class MerchantsController < ApplicationController
  layout 'template'
  
  before_filter :merchant_authorize
  
  # GET /merchants
  # GET /merchants.xml
  def index
    @merchant = Merchant.find(session[:user_id])
    
    @auctions = Auction.find(:all, :conditions => ["`merchant_id` = ? and auction_start <= ? and auction_end >= ? and auction_ended != ? and auction_deleted != ?",@merchant.merchant_id, Time.now.iso8601, Time.now.iso8601, "1", "1"], :order => "auction_start desc")
    
    @auctions.each do |a|
      url = URI.parse('http://ayopa1dev.happyjacksoftware.com:8080/AyopaServer/current-auction-info')
      post_args1 = {'auctionID' => a.auction_id}
      resp, data = Net::HTTP.post_form(url, post_args1)
      result = JSON.parse(data)
      
      a.current_price = result['current_price']  
      a.current_level = result['current_level']
      a.next_price = result['next_price']
      a.next_level = result['next_level']
      a.lowest_price = result['lowest_price']
      a.lowest_level = result['lowest_level']
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @merchants }
    end
  end
  
  def set_password
    if !params[:merchant][:password].blank? && !params[:merchant][:password_confirmation].blank? && params[:merchant][:password] == params[:merchant][:password_confirmation]
      user = Merchant.find(params[:merchant][:id])
      if user
        user.set_password(params[:merchant][:password], params[:merchant][:password_confirmation])
        flash[:alert] = "Password has been set"
      else
        flash[:alert] = "Password cannot be set at this time"
      end
    else
      flash[:alert] = "Password/Password confirmation blank or passwords do not match"
    end
    redirect_to :controller => "merchants", :action => "index"
  end

  # GET /merchants/1
  # GET /merchants/1.xml
  def show
    @merchant = Merchant.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @merchant }
    end
  end

  # GET /merchants/new
  # GET /merchants/new.xml
  def new
    @merchant = Merchant.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @merchant }
    end
  end

  # GET /merchants/1/edit
  def edit
    @merchant = Merchant.find(params[:id])
  end

  # POST /merchants
  # POST /merchants.xml
  def create
    @merchant = Merchant.new(params[:merchant])

    respond_to do |format|
      if @merchant.save
        format.html { redirect_to(@merchant, :notice => 'Merchant was successfully created.') }
        format.xml  { render :xml => @merchant, :status => :created, :location => @merchant }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @merchant.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /merchants/1
  # PUT /merchants/1.xml
  def update
    @merchant = Merchant.find(session[:user_id])

    respond_to do |format|
      if @merchant.update_attributes(params[:merchant])
        format.html { redirect_to(:controller => 'merchants', :action => 'index', :notice => 'Merchant was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @merchant.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /merchants/1
  # DELETE /merchants/1.xml
  def destroy
    @merchant = Merchant.find(params[:id])
    @merchant.destroy

    respond_to do |format|
      format.html { redirect_to(merchants_url) }
      format.xml  { head :ok }
    end
  end
end
