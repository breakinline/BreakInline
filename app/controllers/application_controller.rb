class ApplicationController < ActionController::Base
  OrderLock = 'OrderLock'
  OrderItemLock = 'OrderItemLock'

  def reprice(order)
    total = 0.0
    order.order_items.each do |orderItem|
      total = total + (orderItem.price * orderItem.quantity)
    end
    order.sub_total = total 
    if session[:taxRate].nil?
      order.tax_total = 0.0
      order.total = total
    else
      order.tax_total = (total * session[:taxRate]).round / 100
      order.total = total + order.tax_total      
    end
    order.save
  end
  def getOrder
    lockId = lock(OrderLock)
    if session[:orderId].nil?
      logger.debug 'no order found in session'
      # see if this user has an order already.
      if session[:profileId].nil?
        logger.debug 'no profile found in session'
        dt = (Time.now - 30.minutes).in_time_zone('UTC')       
        # Try and recycle an unused order.  
        order = Order.find_by_location_id_and_status_and_user_id(session[:locationId],Order::NEW,nil,:conditions=>["updated_at<?",dt])
        if order.nil?
          logger.debug('no recyclable order found')
          order = Order.new
          order.location_id = session[:locationId]
          order.status = Order::NEW
          order.save        
        else
          # this should reserve our order.
          logger.debug('found recyclable order')
          order.updated_at=Time.now.in_time_zone('UTC')
          order.save
        end     
      else
        order = Order.find_by_user_id_and_location_id_and_status(session[:profileId], session[:locationId], Order::NEW) 
        if order.nil? 
          logger.debug 'could not find an order for this profile.'
          dt = (Time.now - 30.minutes).in_time_zone('UTC')       
          # Try and recycle an unused order.  
          order = Order.find_by_location_id_and_status_and_user_id(session[:locationId],Order::NEW,nil,:conditions=>["updated_at<?",dt])
          if order.nil?
            logger.debug('could not find recyclable order')
            order = Order.new
            order.location_id = session[:locationId]
            order.user_id = session[:profileId]
            order.status = Order::NEW
            order.save        
          else
            # this should reserve our order.
            logger.debug('found recyclable order')
            order.user_id = session[:profileId]
            order.updated_at=Time.now.in_time_zone('UTC')
            order.save
          end 
        end
      end
      logger.debug('session[:order] is set to ' + order.id.to_s)     
      logger.debug('timestamp: ' + order.updated_at.to_s)
      session[:orderId] = order.id
    else
      order = Order.find_by_id(session[:orderId]) 
      if order.nil? or order.status != Order::NEW
        order = Order.new
        order.location_id = session[:locationId]
        order.user_id = session[:profileId]
        order.status = Order::NEW
        order.save        
      end 
      session[:orderId] = order.id
    end
    reprice(order)  
    releaseLock(lockId)
    return order
  end
  def lock(resource)
  #  lock = Lock.find_by_resource_and_session_id(resource,session[:session_id])
  #  if (lock.nil?)
  #    lock = Lock.new
  #    lock.resource = resource
  #    lock.session_id = session[:session_id]
  #    lock.save
  #    logger.debug('claimed lock: ' + lock.id.to_s + ' for resource: ' + resource)
  #    return lock.id
  #  else 
  #    (1..10).each do |i|
  #      sleep 1.0
  #      lock = Lock.find_by_resource_and_session_id(resource,session[:session_id])
  #      if lock.nil?
  #        lock = Lock.new
  #        lock.resource = resource
  #        lock.session_id = session[:session_id]
  #        lock.save
  #        logger.debug('claimed lock: ' + lock.idto_s + ' for resource: ' + resource)
  #        return lock.id         
  #      end
  #    end
  #  end
  end
  def releaseLock(lockId)
    #Lock.delete(lockId)
    #logger.debug('released lock: ' + lockId.to_s)
  end
end
  