class OrderPayment < ActiveRecord::Base
  belongs_to :order
  
  def maskedCard
    mCard = ''
    mlen = self.card_number.length - 4
    (1..mlen).each do |i|
      mCard = mCard + 'x'
    end
    mCard = mCard + self.card_number[mlen..-1]
    return mCard  
  end  
end
