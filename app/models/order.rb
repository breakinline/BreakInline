class Order < ActiveRecord::Base
  NEW = "New"
  PREPARE = "Prepare"
  HOLD = "Hold"
  PICKUP = "Pickup"
  COMPLETE = "Complete"
  has_many :order_items
  has_many :order_payments
  belongs_to :user
  belongs_to :location
  
  def order_items_by_item_for
    map = Hash.new
    self.order_items.each do |orderItem|
      if map[orderItem.item_for].nil?
        map[orderItem.item_for] = Array.new
      end
      arraySize = map[orderItem.item_for].count
      map[orderItem.item_for][arraySize] = orderItem
    end
    return map
  end
  def order_item_not_choice_option
  	array = Array.new
  	self.order_items.each do |orderItem|
  		if orderItem.item_type == OrderItem::MENU_ITEM
  			array[array.count] = orderItem
  		end
  	end
  	return array
  end
end
