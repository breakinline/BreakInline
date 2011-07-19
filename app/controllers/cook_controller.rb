class CookController < ApplicationController
  layout 'cook_layout'
  before_filter :require_ssl, :only => [:login]
  def index
    unless params[:id].nil?
      session[:locationId] = params[:id]
    end 

    unless session[:locationId].nil?   
      # load our orders.
      status = Order::PREPARE
      unless params[:status].nil?
        status = params[:status]
      end
      unless session[:profileId].nil?
        @profile = User.find(session[:profileId])
        @orders = Order.find(:all, :conditions => 'status = "' + status + '" and location_id=' + session[:locationId].to_s)
      end
    end
  end
  def login
    @profile = User.find_by_email_and_password(params[:email], params[:password]) 
    if @profile.nil?
      render :text => '{"iserror":true,"message":"That user was not found","showlocations":false}'
    elsif @profile.locations.count > 1
      session[:profileId] = @profile.id
      if params[:locationId].nil?
        json = '{"iserror":false,"message":"","showlocations":true, "locations":[';
        @profile.locations.each do |location|
          json = json + '{"id":' + location.id.to_s + ',' + '"name":"' + location.name + '"},'
        end
        json = json.chop() + ']}';
        render :text => json
      else 
        session[:locationId] = params[:locationId]
        render :text => '{"iserror":false,"message":"","showlocations":false}'        
      end
    else
      session[:profileId] = @profile.id
      session[:locationId] = @profile.locations[0].id
      render :text => '{"iserror":false,"message":"","showlocations":false}'
    end
  end
  def refreshMyAccount
    @profile = User.find(session[:profileId])
    render :partial => 'layouts/cook_header'
  end
  def refresh
    status = Order::PREPARE
    unless params[:status].nil?
      status = params[:status]
    end   
    @orders = Order.find(:all, :conditions => 'status = "' + status + '" and location_id=' + session[:locationId].to_s)
    unless session[:profileId].nil?
      @profile = User.find(session[:profileId])
    end  
    render :partial => "shared/cook_orders"  
  end
  def logout
    session["profileId"] = nil
    render 'index'
  end
  def orderDetail
    @order = Order.find(params[:id])
    @profile = User.find(session[:profileId])
    render 'cook_detail'
  end
  def complete
    order = Order.find(params[:id])
    order.status = Order::COMPLETE
    order.save
    @profile = User.find(session[:profileId])
    @orders = Order.find(:all, :conditions => 'status = "' + Order::PREPARE + '" and location_id=' + session[:locationId].to_s)
    render 'index'
  end
  def pickup
    order = Order.find(params[:id])
    order.status = Order::PREPARE
    order.save
    @profile = User.find(session[:profileId])
    @orders = Order.find(:all, :conditions => 'status = "' + Order::PREPARE + '" and location_id=' + session[:locationId].to_s)
    render 'index'
  end
  
end