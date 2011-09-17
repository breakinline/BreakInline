class MobileController < ApplicationController
  layout 'mobile_layout'  
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
  def company
    @company = Company.find(params[:id]) 
    session[:context] = @company.context   
    unless session[:profileId].nil?
      @profile = User.find(session[:profileId])
    end
  end  
end