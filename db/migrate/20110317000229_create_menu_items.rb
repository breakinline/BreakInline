class CreateMenuItems < ActiveRecord::Migration
  def self.up
    create_table :menu_items do |t|
      t.integer :category_id
      t.string :name
      t.string :description
      t.decimal :price
      t.integer :position

      t.timestamps
    end
  end

  def self.down
    drop_table :menu_items
  end
end
