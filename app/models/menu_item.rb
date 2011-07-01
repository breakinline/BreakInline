class MenuItem < ActiveRecord::Base
  belongs_to :category
  has_many :choice_option_groups
  has_one :order_item
  default_scope :order => 'menu_items.position ASC'
end
