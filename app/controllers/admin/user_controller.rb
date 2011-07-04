class Admin::UserController < ApplicationController
  def update
    location = Location.find(params[:parent])
    user = User.find(params[:id])
    users = User.find_all_by_email(params[:email])
    if users.size > 1
      render :json => '{"failure":"User email: ' + params[:email] + ' already exists in location: ' + location.name + '."}'  
    else
      user.role = params[:role]
      user.first_name = params[:firstName]
      user.last_name = params[:lastName]
      user.email = params[:email].upcase
      user.address_1 = params[:address1]
      user.address_2 = params[:address2]
      user.role = params[:role].downcase
      user.city = params[:city]
      user.state = params[:state]
      user.postal = params[:postal]
      user.phone = params[:phone]
      user.card_type = params[:cardType]
      user.expiration_month = params[:expMonth]
      user.expiration_year = params[:expYear]
      unless user.card_number.match(/^xxxx/)
        user.card_number = params[:cardNumber]        
      end
      user.save
      render :json => '{"success":"Updated Successfully", "name":"' + user.first_name + ' ' + user.last_name + '","id":"' +
        'src/' + location.company_id.to_s + '/' + location.id.to_s + '/users/' + user.id.to_s + '","iconCls":"user"}'
    end
  end
  def show
    user = User.find(params[:id])
    user.card_number = maskCard(user.card_number)
    render :json => user.to_json
  end   
  def destroy
    LocationsUser.delete_all(['user_id=?', params[:id]])
    User.delete(params[:id])
    render :json => '{"success":"Successfully deleted"}'
  end 
  def create
    location = Location.find(params[:parent])
    users = User.find_by_email(params[:email])
    unless users.nil?
      render :json => '{"failure":"User email: ' + params[:email] + ' already exists in location: ' + location.name + '."}'  
    else
      user = User.new
      user.role = params[:role].downcase
      user.first_name = params[:firstName]
      user.last_name = params[:lastName]
      user.email = params[:email].upcase
      user.address_1 = params[:address1]
      user.address_2 = params[:address2]
      user.city = params[:city]
      user.state = params[:state]
      user.postal = params[:postal]
      user.phone = params[:phone]
      user.card_type = params[:cardType]
      user.expiration_month = params[:expMonth]
      user.expiration_year = params[:expYear]
      user.card_number = params[:cardNumber]
      user.save
      locationsUser = LocationsUser.new
      locationsUser.user_id = user.id
      locationsUser.location_id = location.id
      locationsUser.save
      render :json => '{"success":"Created Successfully", "name":"' + user.first_name + ' ' + user.last_name + '","id":"' +
        'src/' + location.company_id.to_s + '/' + location.id.to_s + '/users/' + user.id.to_s + '","iconCls":"user"}'
    end
  end
  
  def maskCard(cardNum)
    mCard = ''
    mlen = cardNum.length - 4
    (1..mlen).each do |i|
      mCard = mCard + 'x'
    end
    mCard = mCard + cardNum[mlen..-1]
    return mCard  
  end  
end