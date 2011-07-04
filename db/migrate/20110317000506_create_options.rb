class CreateOptions < ActiveRecord::Migration
  def self.up
    create_table :options do |t|
      t.integer :menu_item_id
      t.string :name
      t.string :groupKey
      t.decimal :price
      t.integer :position

      t.timestamps
    end
  end

  def self.down
    drop_table :options
  end
end