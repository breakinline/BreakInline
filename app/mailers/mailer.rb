class Mailer < ActionMailer::Base
  default :from => "breakinline@gmail.com"
  def reset_password_email(user, password)
    @user = user
    @password = password
    mail(:to => user.email,
         :subject => "Reset Password")
  end
  def order_confirmation_email(user, order)
    @user = user
    @order = order
    mail(:to => user.email,
         :subject => "Order Confirmation")    
  end
end
