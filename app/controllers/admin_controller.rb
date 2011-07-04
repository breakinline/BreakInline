class AdminController < ApplicationController
  layout 'admin_layout'
  def show
    @company = Company.find(params[:id])
    logger.debug('set company: ' + @company.id.to_s)
    session[:companyId] = params[:id]
  end
  def login
    company = Company.find(session[:companyId])
    users = User.find_all_by_email(params[:email].to_s.upcase)
    
    if users.nil?
      render :json => '{"failure":"Sorry.  That email is not recognized."}'
    else
      locationValid = false
      passwordValid = false
      roleValid = false
      users.each do |user|
        company.locations.each do |location|
          lu = LocationsUser.find_by_user_id_and_location_id(user.id, location.id)
          unless lu.nil?
            locationValid = true
            if user.password == params[:password]
              passwordValid = true
              if user.role == 'admin'
                roleValid = true
                session[:userId] = user.id
              end
            end
          end
        end
      end
      if locationValid == false
        render :json => '{"failure":"Sorry.  That email is not recognized for company: ' + company.name  + '."}'
      elsif passwordValid == false
        render :json => '{"failure":"Sorry.  The supplied password does not match what is on file."}'
      elsif roleValid == false
        render :json => '{"failure":"Sorry.  This user does not have authorization for administration."}'
      else
        render :json => '{"success":"Successfully deleted"}'
      end
    end
  end
  def get_node
    if params[:node].nil? 
      render :text => '[]'
      return
    end 
    jsonSz = '['
    path = params[:node].split('/')
    if path.length == 2
      company = Company.find(path[1])
      company.locations.each do |location|
        jsonSz = jsonSz + '{"text":"' + location.name + '","id":"src/' + company.id.to_s + '/' + location.id.to_s + '","iconCls":"location"},'
      end
    elsif path.length == 3
      company = Company.find(path[1])
      location = Location.find(path[2])
      location.categories.each do |category|
        jsonSz = jsonSz + '{"text":"' + category.name + '","id":"src/' + company.id.to_s + '/' + location.id.to_s + '/' + category.id.to_s + 
          '","iconCls":"category"},'         
      end
      jsonSz = jsonSz + '{"text":"Users","id":"src/' + company.id.to_s + '/' + location.id.to_s + '/users","cls":"folder"},'
    elsif path.length == 4
      if path[3] == 'users'
        location = Location.find(path[2])
        users = location.users
        users.each do |user|
          jsonSz = jsonSz + '{"text":"' + user.first_name + ' ' + user.last_name + '","id":"src/' + location.company.id.to_s + '/' + 
            location.id.to_s + '/users/' + user.id.to_s + '","iconCls":"user"},'  
        end        
      else
        category = Category.find(path[3])
        category.menu_items.each do |menuItem|
          jsonSz = jsonSz + '{"text":"' + menuItem.name + '","id":"src/' + category.location.company.id.to_s + '/' + 
            category.location.id.to_s + '/' + category.id.to_s + '/' + menuItem.id.to_s + '","iconCls":"menu_item"},'  
        end        
      end
    elsif path.length == 5
      if path[3] != 'users'
        menuItem = MenuItem.find(path[4])
        menuItem.choice_option_groups.each do |choiceOptionGroup|
          jsonSz = jsonSz + '{"text":"' + choiceOptionGroup.name + '","id":"src/' + menuItem.category.location.company.id.to_s + 
            '/' + menuItem.category.location.id.to_s + '/' + menuItem.category.id.to_s + '/' + menuItem.id.to_s + '/' +
            choiceOptionGroup.id.to_s + '","cls":"folder"},'  
        end
      end
    elsif path.length == 6
      choiceOptionGroup = ChoiceOptionGroup.find(path[5])
      choiceOptionGroup.choice_options.each do |choiceOption|
        jsonSz = jsonSz + '{"text":"' + choiceOption.name + '","id":"src/' +choiceOptionGroup.menu_item.category.location.company.id.to_s + 
          '/' + choiceOptionGroup.menu_item.category.location.id.to_s + '/' + choiceOptionGroup.menu_item.category.id.to_s + '/' + 
          choiceOptionGroup.menu_item.id.to_s + '/' + choiceOptionGroup.id.to_s + '/' + choiceOption.id.to_s + '","iconCls":"option","leaf":true},'  
      end
    end
    if jsonSz.length > 1
      jsonSz = jsonSz.chop
    end
    jsonSz = jsonSz + ']'
    render :text => jsonSz
  end  
end