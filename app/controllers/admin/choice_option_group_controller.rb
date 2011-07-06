class Admin::ChoiceOptionGroupController < ApplicationController
  def update
    menuItem = MenuItem.find(params[:parent])
    choiceOptionGroup = ChoiceOptionGroup.find(params[:id])
    groups = ChoiceOptionGroup.find_all_by_name_and_menu_item_id(params[:name], menuItem.id)
    if groups.size > 1
      render :json => '{"failure":"Group name: ' + params[:name] + ' already exists in menu item: ' + menuItem.name + '."}'  
    else
      if params[:itemType] == 'choice'
        choiceOptionGroup.item_type = 2
      else
        choiceOptionGroup.item_type = 3
      end
      choiceOptionGroup.position = params[:position]
      choiceOptionGroup.name = params[:name]
      choiceOptionGroup.max_quantity = params[:maxQuantity]
      choiceOptionGroup.description = params[:description]
      choiceOptionGroup.save
      render :json => '{"success":"Updated Successfully", "name":"' + choiceOptionGroup.name + '","id":"' +
        'src/' + menuItem.category.location.company_id.to_s + '/' + menuItem.category.location_id.to_s + '/' + 
        menuItem.category_id.to_s + '/' + menuItem.id.to_s + '/' + choiceOptionGroup.id.to_s + '","iconCls":"choice_option_group"}'
    end
  end
  def show
    choiceOptionGroup = ChoiceOptionGroup.find(params[:id])
    render :json => choiceOptionGroup.to_json    
  end   
  def destroy
    choiceOptionGroup = ChoiceOptionGroup.find(params[:id])
    ChoiceOption.delete_all(['choice_option_group_id=?', choiceOptionGroup.id.to_s])
    ChoiceOptionGroup.delete(params[:id])
    render :json => '{"success":"Successfully deleted"}'
  end 
  def create
    menuItem = MenuItem.find(params[:parent])
    choiceOptionGroup = ChoiceOptionGroup.find_by_name_and_menu_item_id(params[:name], menuItem.id)
    unless choiceOptionGroup.nil?
      render :json => '{"failure":"Group name: ' + params[:name] + ' already exists in menu item: ' + menuItem.name + '."}'      
    else
      choiceOptionGroup = ChoiceOptionGroup.new
      choiceOptionGroup.name = params[:name]
      choiceOptionGroup.description = params[:description]
      choiceOptionGroup.position = params[:position]
      if params[:itemType] == 'choice'
        choiceOptionGroup.item_type = 2
      else
        choiceOptionGroup.item_type = 3
      end
      choiceOptionGroup.menu_item_id = menuItem.id
      choiceOptionGroup.max_quantity = params[:maxQuantity]
      choiceOptionGroup.save
      render :json => '{"success":"Updated Successfully", "name":"' + choiceOptionGroup.name + '","id":"' +
        'src/' + menuItem.category.location.company_id.to_s + '/' + menuItem.category.location_id.to_s + '/' + 
        menuItem.category_id.to_s + '/' + menuItem.id.to_s + '/' + choiceOptionGroup.id.to_s + '","iconCls":"choice_option_group"}'
      end
  end
end
