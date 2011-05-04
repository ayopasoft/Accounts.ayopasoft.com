require 'net/http'
require 'json'
require 'time'

class AdminsController < ApplicationController
  layout 'template'
  
  before_filter :admin_authorize
  
  def new_admin
    if params[:admin][:admin_email].blank?
        flash[:alert] = "You must enter an email address"
        redirect_to :controller => 'admins', :action => 'index'
      else
        user = User.lookup_by_email(params[:admin][:admin_email])
        if user
          flash[:alert] = "This email is already registered with Ayopa"
          redirect_to :controller => 'admins', :action => 'index'
        else
           @user = Admin.create(params[:admin])
           reset_code = @user.set_reset_code
           Mailer.deliver_new_admin_account reset_code, @user, (reset_password_url :reset_code => reset_code)
          flash[:alert] = "Email sent to #{@user.admin_email}"
          redirect_to :controller => 'admins', :action => 'index'
        end
     end
  end
  
  def set_password
    if !params[:admin][:password].blank? && !params[:admin][:password_confirmation].blank? && params[:admin][:password] == params[:admin][:password_confirmation]
      user = Admin.find(params[:admin][:id])
      if user
        user.set_password(params[:admin][:password], params[:admin][:password_confirmation])
        flash[:alert] = "Password has been set"
      else
        flash[:alert] = "Password cannot be set at this time"
      end
    else
      flash[:alert] = "Password/Password confirmation blank or passwords do not match"
    end
    redirect_to :controller => "admins", :action => "index"
  end
  
  def new_merchant
      if params[:admin][:email].blank?
        flash[:alert] = "You must enter an email address"
        redirect_to :controller => 'admins', :action => 'index'
      else
      
      user = User.lookup_by_email(params[:admin][:email])
        if user
          flash[:alert] = "This email is already registered with Ayopa"
          redirect_to :controller => 'admins', :action => 'index'
        else
           @user = Merchant.create(params[:admin])
           reset_code = @user.set_reset_code
           Mailer.deliver_new_merchant_account reset_code, @user, (reset_password_url :reset_code => reset_code)
          flash[:alert] = "Email sent to #{@user.email}"
          redirect_to :controller => 'admins', :action => 'index'
        end
       end     
   
  end
  
  def inactivate_merchant
     user = Merchant.find(params[:merchant][:id])
     if user
       user.inactivate
     end
     redirect_to :controller => 'admins', :action => 'index'
  end
  
  def activate_merchant
    user = Merchant.find(params[:merchant][:id])
     if user
       user.activate
     end
     redirect_to :controller => 'admins', :action => 'index'
  end
  
  
  # GET /admins
  # GET /admins.xml
  def index
    
    @admins = Admin.find(:all)
    
    @merchants = Merchant.find(:all, :order => "merchant_name")
    
    @auctions = Auction.find(:all, :conditions => ["auction_start <= ? and auction_end >= ? and auction_ended != ? and auction_deleted != ?", Time.now.iso8601, Time.now.iso8601, "1", "1"], :order => "auction_start desc")
    
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
      a.rebate_total = result['rebate_total']
      a.commission_total = result['commission_total']
      a.auction_total = result['auction_total']
      if a.auction_end < Time.now.iso8601 
        a.auction_expired = 1
      end
      
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @admins }
    end
  end

  # GET /admins/1
  # GET /admins/1.xml
  def show
    @admin = Admin.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @admin }
    end
  end

  # GET /admins/new
  # GET /admins/new.xml
  def new
    @admin = Admin.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @admin }
    end
  end

  # GET /admins/1/edit
  def edit
    @admin = Admin.find(params[:id])
  end

  # POST /admins
  # POST /admins.xml
  def create
    @admin = Admin.new(params[:admin])
    @admin.set_password(params[:admin][:password],params[:admin][:password_confirmation])
    respond_to do |format|
      if @admin.save
        format.html { redirect_to(@admin, :notice => 'Admin was successfully created.') }
        format.xml  { render :xml => @admin, :status => :created, :location => @admin }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @admin.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admins/1
  # PUT /admins/1.xml
  def update
    @admin = Admin.find(params[:admin][:id])

    respond_to do |format|
      if @admin.update_attributes(params[:admin])
        format.html { redirect_to(:controller => "admins", :action => "index") }
        format.xml  { head :ok }
      else   
        format.html { render :action => "index" }
        flash.now[:alert] = "Problem saving admin"
        format.xml  { render :xml => @admin.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admins/1
  # DELETE /admins/1.xml
  def destroy
    @admin = Admin.find(params[:id])
    @admin.destroy

    respond_to do |format|
      format.html { redirect_to(admins_url) }
      format.xml  { head :ok }
    end
  end
end
