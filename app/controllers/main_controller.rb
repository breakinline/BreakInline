class MainController < ApplicationController
  before_filter :require_ssl, :only => [:login, :register, :resetPassword]
  def deleteItem
    # first delete our options and choices.
    OrderItem.delete_all(["parent_order_item_id = ?", params[:orderItemId]])
    OrderItem.delete(params[:orderItemId])
    render :text => "success"
  end
  def show
    @location = Location.find(params[:id])
    session[:context] = @location.context
    session[:locationId] = @location.id
    @order = getOrder()
    session[:taxRate] = @location.tax_rate
    @categories = Category.find_all_by_location_id(params[:id])
    @profile = nil
    unless session[:profileId].nil?
        @profile = User.find(session[:profileId])
    end 
  end
  def company
    @company = Company.find(params[:id]) 
    session[:context] = @company.context   
    unless session[:profileId].nil?
      @profile = User.find(session[:profileId])
    end
  end
  def login
    @profile = User.find_by_email_and_password(params[:email].upcase, params[:password])   
    if @profile.nil? 
      render :text => "That user was not found.  Please re-enter"
    else
      session[:profileId] = @profile.id
      # save our profile id in our order.  
      order = Order.find_by_location_id_and_status_and_user_id(session[:locationId],Order::NEW,@profile.id)
      if order.nil?
        order = Order.find(session[:orderId])
        order.user_id = @profile.id        
        order.save        
      else
        # We have a previous order.  Delete it's contents and copy our session order over.
        OrderItem.delete_all(['order_id=?', order.id])
        unless session[:orderId].nil?
          sessionOrder = Order.find(session[:orderId])
          sessionOrder.order_items.each do |item|
            if item.item_type == OrderItem::MENU_ITEM
              orderItem = OrderItem.new
              orderItem.order_id = order.id
              orderItem.menu_item_id = item.menu_item_id
              orderItem.name = item.name
              orderItem.price = item.price
              orderItem.quantity = item.quantity
              orderItem.comment = item.comment
              orderItem.item_for = item.item_for
              orderItem.item_type = item.item_type
              orderItem.save  
              parentItemId = orderItem.id        
              item.choice_options(sessionOrder.order_items).each do |choice_option|
                orderItem = OrderItem.new
                orderItem.order_id = order.id
                orderItem.choice_option_id = item.choice_option_id
                orderItem.name = item.name
                orderItem.price = item.price
                orderItem.quantity = item.quantity
                orderItem.comment = item.comment
                orderItem.item_for = item.item_for
                orderItem.item_type = item.item_type
                orderItem.parent_order_item_id = parentItemId
                orderItem.save  
              end
            end
          end
          # clear our session order
          OrderItem.delete_all(['order_id=?', session[:orderId]])
          sessionOrder.user_id = nil
          sessionOrder.save
          session[:orderId] = order.id          
        end
      end
      render :text => "success"      
    end
  end
  def copyOrder
    currentOrder = Order.find(session[:orderId])
    order2copy = Order.find(params[:orderId])
    unless currentOrder.nil?
      OrderItem.delete_all(['order_id=?', currentOrder.id])
      order2copy.order_items.each do |item|
        if item.item_type == OrderItem::MENU_ITEM
          orderItem = OrderItem.new
          orderItem.order_id = order.id
          orderItem.menu_item_id = item.menu_item_id
          orderItem.name = item.name
          orderItem.price = item.price
          orderItem.quantity = item.quantity
          orderItem.comment = item.comment
          orderItem.item_for = item.item_for
          orderItem.item_type = item.item_type
          orderItem.save  
          parentItemId = orderItem.id        
          item.choice_options(sessionOrder.order_items).each do |choice_option|
            orderItem = OrderItem.new
            orderItem.order_id = order.id
            orderItem.choice_option_id = item.choice_option_id
            orderItem.name = item.name
            orderItem.price = item.price
            orderItem.quantity = item.quantity
            orderItem.comment = item.comment
            orderItem.item_for = item.item_for
            orderItem.item_type = item.item_type
            orderItem.parent_order_item_id = parentItemId
            orderItem.save  
          end
        end          
      end
    end
    render :text => "success"
  end
  def refreshPrevOrders
    unless session[:profileId].nil?
      @prevorders = Order.limit(5).find_all_by_user_id(session[:profileId], :conditions => "status <> 'New'", 
                                                                   :order => "placed_at desc")
    end
    render :partial => "shared/prev_orders"   
  end
  def checkout
    order = getOrder()
    location = Location.find(session[:locationId])
    profile = User.find(session[:profileId])
        
    ActiveMerchant::Billing::Base.mode = :test
    credit_card = ActiveMerchant::Billing::CreditCard.new(
      :number => profile.card_number,
      :month => profile.expiration_month.to_s,
      :year => profile.expiration_year.to_s,
      :first_name => profile.first_name,
      :last_name => profile.last_name,
      :type => profile.card_type,
      :verification_value => profile.cvv)

    gateway = ActiveMerchant::Billing::AuthorizeNetGateway.new(
      :login => location.merchant_id,
      :password => location.api_transaction_key)
    billing_address = {:name => profile.first_name + ' ' + profile.last_name,
      :address1 => profile.address_1,
      :address2 => profile.address_2,
      :city => profile.city,
      :state => profile.state,
      :zip => profile.postal,
      :phone => profile.phone,
      :country => 'US'}
        
    options = {:address => {}, :billing_address => billing_address}
      
    response = gateway.purchase(order.total, credit_card, options)
      
    if response.success?
      gateway.capture(order.total, response.authorization)
      render :text => "success"
      # copy our payment info from user to order.
      OrderPayment.delete_all(['order_id=?', order.id])
      orderPayment = OrderPayment.new
      orderPayment.address_1 = profile.address_1
      orderPayment.address_2 = profile.address_2
      orderPayment.city = profile.city
      orderPayment.state = profile.state
      orderPayment.postal = profile.postal
      orderPayment.phone = profile.phone
      orderPayment.last_name = profile.last_name
      orderPayment.first_name = profile.first_name
      orderPayment.order_id = order.id
      orderPayment.expiration_month = profile.expiration_month
      orderPayment.expiration_year = profile.expiration_year
      orderPayment.card_type = profile.card_type
      orderPayment.card_number = profile.card_number
      orderPayment.expiration_year = profile.expiration_year            
      orderPayment.transaction_id = response.authorization
      orderPayment.save
      order.status = Order::PREPARE
      if params[:pickupDate].nil? == false && params[:pickupDate].length > 0
        order.pickup_at = DateTime.strptime(params[:pickupDate], "%m/%d/%Y %I:%M %p")
      else
        order.pickup_at = Time.now + location.delivery_padding.minutes
      end
      order.placed_at = Time.now
      order.save         
    else
      render :text => "Sorry, we were unable to process that card. " + response.message.to_s
    end
  end
  def getProfile
    json = ActiveSupport::JSON
    profile = User.find(session[:profileId])
    profile.card_number = profile.maskedCard
    render :text => json.encode(profile)
  end
  def resetPassword
    user = User.find_by_email(params[:email])
    if user.nil?
      render :text => "Sorry, we were unable to find that email"
    else
      if user.answer.upcase == params[:answer].to_s.upcase
        Mailer.reset_password_email(user, "temppass").deliver
        render :text => "success"
      else 
        render :text => "Your answer does not match your profile"
      end
    end
  end
  def thankyou
    @prevorder = Order.find(params[:prevOrderId])
    session[:orderId] = nil
    @profile = User.find(session[:profileId])
    Mailer.order_confirmation_email(@profile, @prevorder).deliver 
    render :partial => "shared/thank_you"
  end
  def thankyoutest
    @prevorder = Order.find(params[:orderId])
    @profile = User.find(session[:profileId])
    render 'thank_you'
  end
  def register
    logger.debug('editmode: ' + params[:editmode].to_s)
    # check and see if we're in editmode
    if params[:editmode] == 'true'
      user = User.find_by_email(params[:email])
    else
      user = User.find_by_email(params[:email])
      unless user.nil?
        render :text => "That email is already registered.  Please try again."
        return
      end
      user = User.new
      user.email = params[:email].upcase
    end
    user.password = params[:password]
    user.last_name = params[:lastname]
    user.first_name = params[:firstname]
    user.address_1 = params[:address1]
    user.address_2 = params[:address_2]
    user.city = params[:city]
    user.state = params[:state]
    user.postal = params[:postal]
    user.phone = params[:phone]
    user.card_type = params[:cardtype]
    if user.role.nil?
      user.role = 'user'
    end
    # if credit card begins with 'X' don't save
    logger.debug('cardno: ' + params[:cardno])
    unless params[:cardno].starts_with? 'xxxx'
    user.card_number = params[:cardno]
    end
    user.expiration_month = params[:expmonth]
    user.expiration_year = params[:expyear]
    user.cvv = params[:cvv]
    user.answer = params[:answer]
    user.challenge = params[:challenge]
    user.save
    if params[:editmode] == 'false'
      # Associate to location
      locationUser = LocationsUser.new
      locationUser.user_id = user.id
      locationUser.location_id = session[:locationId]
      locationUser.save
    end    
    order = getOrder();
    order.user_id = user.id  
    order.save
    session[:profileId] = user.id
    render :text => "success"    
  end
  def logout
    session[:profileId] = nil
    session[:orderId] = nil
    render :text => "success"
  end
  def refreshMyAccount
    unless session[:profileId].nil?
      @profile = User.find(session[:profileId])
    end
    render :partial => "layouts/header"
  end
  def refreshOrder
    @order = getOrder()
    @location = Location.find(session[:locationId])
    unless session[:profileId].nil?
      @profile = User.find(session[:profileId])
    end
    render :partial => "shared/order_summary"
  end 
  def updateQuantity
    lockId = lock(OrderItemLock)
    orderItem = OrderItem.find(params[:orderItemId])
    orderItem.quantity = params[:quantity]
    orderItem.save
    releaseLock(lockId)
    render :text => "success"
  end
  def updateOrderItem
    orderItem = OrderItem.find(params[:orderItemId])
    orderItem.comment = params[:comment];
    orderItem.save
    order = getOrder()
    lockId = lock(OrderItemLock)
    OrderItem.delete_all(['parent_order_item_id=?', orderItem.id])
    pos = 1
    until params["option#{pos}"].nil? do
      choice_option = ChoiceOption.find(params["option#{pos}"])
      optionItem = OrderItem.new
      optionItem.order_id = order.id
      optionItem.choice_option_id = choice_option.id
      optionItem.name = choice_option.name
      if choice_option.price.nil?
        optionItem.price = 0.0
      else
        optionItem.price = choice_option.price
      end
      optionItem.quantity = 1
      optionItem.parent_order_item_id = orderItem.id
      optionItem.item_type = OrderItem::OPTION_ITEM
      optionItem.save      
      pos += 1
    end
    pos = 1
    until params["choice#{pos}"].nil? do
      choice_option = ChoiceOption.find(params["choice#{pos}"])
      choiceItem = OrderItem.new
      choiceItem.order_id = order.id
      choiceItem.choice_option_id = choice_option.id
      choiceItem.name = choice_option.name
      if choice_option.price.nil?
        choiceItem.price = 0.0
      else
        choiceItem.price = choice_option.price
      end
      choiceItem.quantity = 1
      choiceItem.item_type = OrderItem::CHOICE_ITEM
      choiceItem.parent_order_item_id = orderItem.id
      choiceItem.save      
      pos += 1
    end   
    releaseLock(lockId) 
    render :text => "success"
  end
  def addItem2Order
    order = getOrder()
    lockId = lock(OrderItemLock)
    menuItem = MenuItem.find(params[:menuItemId])
    # add our item
    orderItem = OrderItem.new
    orderItem.order_id = order.id
    orderItem.menu_item_id = params[:menuItemId]
    orderItem.name = menuItem.name
    unless params[:itemFor].nil?
      orderItem.item_for = params[:itemFor]
    end
    orderItem.price = menuItem.price
    orderItem.quantity = 1
    orderItem.comment = params[:comment]
    orderItem.item_type = OrderItem::MENU_ITEM
    orderItem.save    
    pos = 1
    until params["option#{pos}"].nil? do
      choiceOption = ChoiceOption.find(params["option#{pos}"])
      optionItem = OrderItem.new
      optionItem.order_id = order.id
      optionItem.choice_option_id = choiceOption.id
      optionItem.name = choiceOption.name
      if choiceOption.price.nil?
        optionItem.price = 0.0
      else
        optionItem.price = choiceOption.price
      end
      optionItem.quantity = 1
      optionItem.parent_order_item_id = orderItem.id
      optionItem.item_type = OrderItem::OPTION_ITEM
      optionItem.save      
      pos += 1
    end
    pos = 1
    until params["choice#{pos}"].nil? do
      choiceOption = ChoiceOption.find(params["choice#{pos}"])
      choiceItem = OrderItem.new
      choiceItem.order_id = order.id
      choiceItem.choice_option_id = choiceOption.id
      choiceItem.name = choiceOption.name
      if choiceOption.price.nil?
        choiceItem.price = 0.0
      else
        choiceItem.price = choiceOption.price
      end
      choiceItem.quantity = 1
      choiceItem.item_type = OrderItem::CHOICE_ITEM
      choiceItem.parent_order_item_id = orderItem.id
      choiceItem.save      
      pos += 1
    end
    releaseLock(lockId)
    render :text => "success"
  end  
end
