class OrderItem < ActiveRecord::Base
  MENU_ITEM = 1
  CHOICE_ITEM = 2
  OPTION_ITEM = 3
  belongs_to :order
  belongs_to :menu_item
  belongs_to :choice_option
  
  def choice_options(orderItems)
    arr = []
    idx = 0
    orderItems.each do |orderItem|
      if orderItem.parent_order_item_id == self.id && orderItem.item_type != MENU_ITEM
        arr[idx] = orderItem
        idx = idx + 1
      end
    end
    return arr
  end
  
  def optionOrderItems(orderItems)
    t_options = []
    idx = 0
    orderItems.each do |orderItem|
      if orderItem.item_type == OPTION_ITEM and orderItem.parent_order_item_id == self.id
        t_options[idx] = orderItem
        idx = idx + 1
      end
    end  
    return t_options 
  end
  
  def choiceOrderItems(orderItems)
    t_choices = [];
    idx = 0;
    orderItems.each do |orderItem|
      if orderItem.item_type == CHOICE_ITEM and orderItem.parent_order_item_id == self.id
        t_choices[idx] = orderItem
        idx = idx + 1
      end
    end    
    return t_choices
  end
  
  def optionIds(orderItems)
    outStr = ''
    idx = 0;
    optionItems = optionOrderItems(orderItems)
    optionItems.each do |orderItem|
      if idx > 0
        outStr = outStr + '|'
      end      
      outStr = outStr + orderItem.choice_option.id.to_s
      idx = idx + 1
    end 
    return outStr    
  end
  
  def choiceIds(orderItems)
    outStr = '';
    idx = 0;
    choiceItems = choiceOrderItems(orderItems)
    choiceItems.each do |orderItem|
      if idx > 0
        outStr = outStr + '|'
      end
      logger.debug('choice_option: ' + orderItem.id.to_s)
      outStr = outStr + orderItem.choice_option.id.to_s
      idx = idx + 1
    end    
    return outStr
  end
end
