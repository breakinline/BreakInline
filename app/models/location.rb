class Location < ActiveRecord::Base
  has_and_belongs_to_many :users
  belongs_to :company
  has_many :categories
  has_many :hours_of_operations
  has_many :order
  validates :name, :presence => true,
            :uniqueness => { :case_sensitive => false }
  validates :address1, :presence => true
  validates :city, :presence => true
  validates :state, :presence => true
  validates :postal, :presence => true
  validates :phone, :presence => true
  validates :company_id, :presence => true
  
  def beginDay(day)
    self.hours_of_operations.each do |hoo|
      if hoo.day == day
        logger.debug('From Time: ' + hoo.from_time.to_s)
        return hoo.from_time
      end
    end
    return '';
  end
  
  def endDay(day)
    self.hours_of_operations.each do |hoo|
      if hoo.day == day
        return hoo.to_time
      end
    end
    return '';    
  end
  
  def beginHour(day) 
    bHour = self.beginDay(day).to_s
    parts = bHour.split(':');
    return parts[0]
  end
  
  def endHour(day)
    bHour = self.endDay(day).to_s
    parts = bHour.split(':');
    return parts[0]    
  end 
end
