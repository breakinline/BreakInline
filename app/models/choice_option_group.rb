class ChoiceOptionGroup < ActiveRecord::Base
  belongs_to :menu_item
  has_many :choice_options
  default_scope :order => 'choice_option_groups.position ASC'  
end