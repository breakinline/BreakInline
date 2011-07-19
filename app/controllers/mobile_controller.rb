RAD_PER_DEG = 0.017453293  #  PI/180
RAD_MILES   = 3956              # radius of the earth in miles


class MobileController < ApplicationController
  layout 'mobile_layout'
  before_filter :require_ssl, :only => [:login]
  def show
    @location = Location.find(params[:id])
    session[:context] = @location.context
    session[:locationId] = @location.id
    @order = getOrder()
    session[:taxRate] = @location.tax_rate
    @categories = Category.find_all_by_location_id(params[:id])
    @profile = nil
    unless session[:profileId].nil?
      @profile = User.find(session[:profileId])
    end    
  end
  def storeLocations
    company = Company.find(session[:companyId])
    @locations = company.locations
    @locations.each do |location|
      distance = haversine_distance(Float(params['lat']), Float(params[:long]), location.latitude, location.longitude)    
      location.distance = (distance * 100).round.to_f / 100
    end
    render :partial =>'/mobile/locations'
  end  
  def haversine_distance(lat1, lon1, lat2, lon2)
    dlon = lon2 - lon1
    dlat = lat2 - lat1

    dlon_rad = dlon * RAD_PER_DEG
    dlat_rad = dlat * RAD_PER_DEG

    lat1_rad = lat1 * RAD_PER_DEG
    lon1_rad = lon1 * RAD_PER_DEG

    lat2_rad = lat2 * RAD_PER_DEG
    lon2_rad = lon2 * RAD_PER_DEG
    
    a = (Math.sin(dlat_rad/2))**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * (Math.sin(dlon_rad/2))**2
    c = 2 * Math.atan2( Math.sqrt(a), Math.sqrt(1-a))
    
    return RAD_MILES * c
  end
  def company
    @company = Company.find(params[:id]) 
    session[:context] = @company.context  
    session[:companyId] = params[:id] 
    unless session[:profileId].nil?
      @profile = User.find(session[:profileId])
    end
  end 
  def map
    @location = Location.find(params[:id])
    render :layout => false
  end
end