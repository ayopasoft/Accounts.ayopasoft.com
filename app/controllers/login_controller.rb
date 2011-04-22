class LoginController < ApplicationController
  
  def index
    id = '556659695'
    buyer = Buyer.find(id)
    puts buyer.buyer_email
  end
  
end
