class Admin::CategoryController < ApplicationController
  def update
    location = Location.find(params[:parent])
    category = Category.find(params[:id])    
    categories = Category.find_all_by_name_and_location_id(params[:name],location.id)
    if categories.size > 1
      render :json => '{"failure":"Category name: ' + params[:name] + ' already exists in location: ' + location.name + '."}'
    else
      category.name = params[:name]
      category.position = params[:position]
      category.description = params[:description]
      category.save
      render :json => '{"success":"Updated Successfully", "name":"' + category.name + '","id":"' +
        'src/' + location.company_id.to_s + '/' + location.id.to_s + '/' + category.id.to_s + '","iconCls":"category"}'
    end
  end
  def show
    category = Category.find(params[:id])
    render :json => category.to_json
  end   
  def destroy
    category = Category.find(params[:id])
    menu_items = MenuItem.find_all_by_category_id(category.id)
    menu_items.each do |menu_item|
      groups = ChoiceOptionGroup.find_all_by_menu_item_id(menu_item.id)
      groups.each do |group|
        ChoiceOption.delete_all(['choice_option_group_id=?', group.id])
      end
      ChoiceOptionGroup.delete_all(['menu_item_id=?', menu_item.id])
    end
    MenuItem.delete_all(['category_id=?', category.id])
    Category.delete(params[:id])
    render :json => '{"success":"Successfully deleted"}'
  end 
  def create
    location = Location.find(params[:parent])
    category = Category.find_by_name_and_location_id(params[:name], location.id)
    if category.nil?
      category = Category.new
      category.location_id = location.id
      category.name = params[:name]
      category.description = params[:description]
      category.position = params[:position]
      category.save
      render :json => '{"success":"Created Successfully", "name":"' + category.name + '","id":"' +
        'src/' + location.company_id.to_s + '/' + location.id.to_s + '/' + category.id.to_s + '","iconCls":"category"}'
    else
      render :json => '{"failure":"Category name: ' + params[:name] + ' already exists in location: ' + location.name + '."}'
    end
  end
  def copy
    
  end
end