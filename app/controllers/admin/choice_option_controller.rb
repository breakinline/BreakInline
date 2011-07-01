class Admin::ChoiceOptionController < ApplicationController
  def update
    choiceOptionGroup = ChoiceOptionGroup.find(params[:parent])
    groups = ChoiceOption.find_all_by_name_and_choice_option_group_id(params[:name], choiceOptionGroup.id)
    if groups.size > 1
      if choiceOptionGroup.item_type == 2
        render :json => '{"failure":"Choice name: ' + params[:name] + ' already exists in group:: ' + choiceOptionGroup.name + '."}'         
      else
        render :json => '{"failure":"Option name already exists in menu item: ' + choiceOptionGroup.name + '."}' 
      end      
    else
      choiceOption = ChoiceOption.find(params[:id])
      choiceOption.price = params[:price]
      choiceOption.position = params[:position]
      choiceOption.name = params[:name]
      choiceOption.save
      render :json => '{"success":"Updated Successfully", "name":"' + choiceOption.name + '","id":"' +
        'src/' + choiceOptionGroup.menu_item.category.location.company_id.to_s + '/' + 
        choiceOptionGroup.menu_item.category.location_id.to_s + '/' + choiceOptionGroup.menu_item.category_id.to_s + 
        '/' + choiceOptionGroup.id.to_s + '/' + choiceOption.id.to_s + '","iconCls":"choice_option","leaf":true}'
    end
  end
  def show
    choiceOption = ChoiceOption.find(params[:id])
    render :json => choiceOption.to_json    
  end   
  def destroy
    ChoiceOption.delete(params[:id])
    render :json => '{"success":"Successfully deleted"}'
  end 
  def create
    choiceOptionGroup = ChoiceOptionGroup.find(params[:parent])
    choiceOption = ChoiceOption.find_by_name_and_choice_option_group_id(params[:name], choiceOptionGroup.id)
    unless choiceOption.nil?
      if choiceOptionGroup.item_type == 2
        render :json => '{"failure":"Choice name: ' + params[:name] + ' already exists in group: ' + choiceOptionGroup.name + '."}'         
      else
        render :json => '{"failure":"Option name: ' + params[:name] + ' already exists in group: ' + choiceOptionGroup.name + '."}' 
      end
    else
      choiceOption = ChoiceOption.new
      choiceOption.price = params[:price]
      choiceOption.position = params[:position]
      choiceOption.name = params[:name]
      choiceOption.choice_option_group_id = choiceOptionGroup.id
      choiceOption.save
      render :json => '{"success":"Updated Successfully", "name":"' + choiceOption.name + '","id":"' +
        'src/' + choiceOptionGroup.menu_item.category.location.company_id.to_s + '/' + 
        choiceOptionGroup.menu_item.category.location_id.to_s + '/' + choiceOptionGroup.menu_item.category_id.to_s + 
        '/' + choiceOptionGroup.id.to_s + '/' + choiceOption.id.to_s + '","iconCls":"choice_option","leaf":true}'
    end
  end
end
