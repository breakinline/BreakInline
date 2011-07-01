class ChoiceOption < ActiveRecord::Base
  belongs_to :choice_option_group
  has_one :order_item
  default_scope :order => 'choice_options.position ASC'
end
