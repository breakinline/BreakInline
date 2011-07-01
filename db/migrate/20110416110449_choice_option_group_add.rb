class ChoiceOptionGroupAdd < ActiveRecord::Migration
  def self.up
    create_table :choice_option_groups do |t|
      t.string :name
      t.integer :num_select
      t.string :description
      t.integer :menu_item_id
      t.integer :position
      t.timestamps
    end
    drop_table :options
    rename_table :choices. :choice_options
    remove_column :choice_options, :group_key
    rename_column :choice_options, :menu_item_id, :choice_option_group_id
    add_column :choice_options, :max_quantity, :integer
    add_column :choice_options, :item_type
    
  end
  
  def self.down
  end
end
