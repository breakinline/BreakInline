class Admin::MenuItemController < ApplicationController
  def update
    category = Category.find(params[:parent])
    menuItem = MenuItem.find(params[:id])
    unless params[:copy].nil?
      menuItemCopy = MenuItem.new
      menuItemCopy.name = menuItem.name + " Copy"
      menuItemCopy.description = menuItem.description
      menuItemCopy.price = menuItem.price
      menuItemCopy.position = menuItem.position + 1
      menuItemCopy.category_id = menuItem.category_id
      menuItemCopy.save
      menuItem.choice_option_groups.each do |group|
        cog = ChoiceOptionGroup.new
        cog.item_type = group.item_type
        cog.position = group.position
        cog.name = group.name
        cog.max_quantity = group.max_quantity
        cog.description = group.description
        cog.menu_item_id = menuItemCopy.id
        cog.save
        group.choice_options.each do |choiceOption|
          choiceOptionCopy = ChoiceOption.new
          choiceOptionCopy.choice_option_group_id = cog.id
          choiceOptionCopy.name = choiceOption.name
          choiceOptionCopy.price = choiceOption.price
          choiceOptionCopy.position = choiceOption.position
          choiceOptionCopy.save
        end
      end
      render :json => '{"success":"Updated Successfully", "name":"' + menuItemCopy.name + '","id":"' +
        'src/' + category.location.company_id.to_s + '/' + category.location_id.to_s + '/' + 
        category.id.to_s + '/' + menuItemCopy.id.to_s + '","iconCls":"menu_item"}'      
    else
      menuItems = MenuItem.find_by_name_and_category_id(params[:name], category.id)
      if menuItems.size > 1
        render :json => '{"failure":"Menu Item name: ' + params[:name] + ' already exists in category: ' + category.name + '."}'
      else
        menuItem.name = params[:name]
        menuItem.description = params[:description]
        menuItem.price = params[:price]
        menuItem.position = params[:position]
        menuItem.save
        render :json => '{"success":"Updated Successfully", "name":"' + menuItem.name + '","id":"' +
          'src/' + category.location.company_id.to_s + '/' + category.location_id.to_s + '/' + 
          category.id.to_s + '/' + menuItem.id.to_s + '","iconCls":"menu_item"}'
      end
    end
  end
  def show
    menuItem = MenuItem.find(params[:id])
    render :json => menuItem.to_json    
  end   
  def destroy
    menuItem = MenuItem.find(params[:id])
    groups = ChoiceOptionGroup.find_all_by_menu_item_id(menuItem.id)
    groups.each do |group|
      ChoiceOption.delete_all(['choice_option_group_id=?', group.id])
    end
    ChoiceOptionGroup.delete_all(['menu_item_id=?', menuItem.id])
    MenuItem.delete(params[:id])
    render :json => '{"success":"Successfully deleted"}'
  end 
  def create
    category = Category.find(params[:parent])
    menuItem = MenuItem.find_by_name_and_category_id(params[:name], category.id)
    unless menuItem.nil?
      render :json => '{"failure":"Menu Item name: ' + params[:name] + ' already exists in category: ' + category.name + '."}'
    else
      menuItem = MenuItem.new
      menuItem.name = params[:name]
      menuItem.description = params[:description]
      menuItem.price = params[:price]
      menuItem.position = params[:position]
      menuItem.category_id = category.id
      menuItem.save
      render :json => '{"success":"Updated Successfully", "name":"' + menuItem.name + '","id":"' +
        'src/' + category.location.company_id.to_s + '/' + category.location_id.to_s + '/' + 
        category.id.to_s + '/' + menuItem.id.to_s + '","iconCls":"menu_item"}'
    end
  end
end