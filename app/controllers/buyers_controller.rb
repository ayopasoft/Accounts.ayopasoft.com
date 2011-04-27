class BuyersController < ApplicationController
  layout 'template'
  before_filter :buyer_authorize
  
  def index
    @buyer = Buyer.find_by_id(session[:user_id])

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
