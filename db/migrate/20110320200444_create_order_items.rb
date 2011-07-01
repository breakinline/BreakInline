class CreateOrderItems < ActiveRecord::Migration
  def self.up
    create_table :order_items do |t|
      t.integer :menuItemId
      t.decimal :price
      t.integer :quantity
      t.string :comment
      t.integer :orderId
      t.integer :itemType
      t.integer :parentOrderItemId
      t.string :name
      t.integer :choice_option_id
      t.timestamps
      t.string :item_for
    end
  end

  def self.down
    drop_table :order_items
  end
end
