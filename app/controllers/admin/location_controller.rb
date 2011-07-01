class Admin::LocationController < ApplicationController
  def update
    company = Company.find(params[:parent])
    location = Location.find(params[:id])
    location.context = params[:context]
    location.delivery_increment = params[:deliveryIncrement]
    location.delivery_padding = params[:deliveryPadding]
    location.merchant_id = params[:merchantId]
    location.api_transaction_key = params[:apiTransactionKey]
    location.tax_rate = params[:taxRate]
    location.phone = params[:phone]
    location.postal = params[:postal]
    location.state = params[:state]
    location.city = params[:city]
    location.address2 = params[:address2]
    location.address1 = params[:address1]
    location.name = params[:name]
    location.save
    render :json => '{"success":"Updated Successfully", "name":"' + location.name + '","id":"' +
      'src/' + company.id.to_s + '/' + location.id.to_s + '","iconCls":"location"}'
  end
  def show
    location = Location.find(params[:id])
    render :json => location.to_json
  end   
end