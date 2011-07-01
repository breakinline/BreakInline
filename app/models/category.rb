class Category < ActiveRecord::Base
  belongs_to :location
  has_many :menu_items
  default_scope :order => 'categories.position ASC'
  
end
