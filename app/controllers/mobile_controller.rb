class MobileController < ApplicationController
  layout 'mobile_layout'  
  def show
    @location = Location.find(params[:id])
    session[:context] = @location.context
    session[:locationId] = @location.id
  end
end