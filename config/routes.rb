Breakinline::Application.routes.draw do
  
  match 'order/additem2order', :to => 'main#addItem2Order'
  match 'main/refreshorder', :to => 'main#refreshOrder'
  match 'order/deleteitem', :to => 'main#deleteItem'
  match 'order/updateorderitem', :to => 'main#updateOrderItem'
  match 'order/updatequantity', :to => 'main#updateQuantity'
  match 'main/refreshmyaccount', :to => 'main#refreshMyAccount'
  match 'main/login', :to => 'main#login'
  match 'main/logout', :to => 'main#logout'
  match 'main/register', :to => 'main#register'
  match 'order/checkout', :to => 'main#checkout'
  match 'order/thankyou', :to => 'main#thankyou'

  match 'main/thankyoutest', :to => 'main#thankyoutest'
  
  match 'main/resetpassword', :to => 'main#resetPassword'
  match 'order/copyorder', :to => 'main#copyOrder'
  match 'main/refreshprevorders', :to => 'main#refreshPrevOrders'
  match 'main/getprofile', :to => 'main#getProfile'
  match 'locations/:id', :to => 'main#show'
  match 'companies/:id', :to => 'main#company'
  
  match 'cookview/refresh', :to => 'cook#refresh'  
  match 'cookview/login', :to => 'cook#login'
  match 'cookview/showlocations', :to => 'cook#showlocations'
  match 'cookview/logout', :to => 'cook#logout'
  match 'cookview/refreshmyaccount', :to => 'cook#refreshMyAccount'
  match 'cookview/:id', :to => 'cook#index'
  match 'cookview/order/:id', :to => 'cook#orderDetail'
  match 'cookview/complete/:id', :to => 'cook#complete'
  match 'cookview/pickup/:id', :to => 'cook#pickup'

  match 'admin/login', :to => 'admin#login'
    
  namespace 'admin' do
    resources :company, :location, :category, :menuItem, :choiceOptionGroup, :choiceOption, :user
  end

  match 'admin/get_node', :to => 'admin#get_node'
  match 'admin/:id', :to => 'admin#show'
  
end