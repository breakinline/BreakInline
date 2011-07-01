class CreateOrders < ActiveRecord::Migration
  def self.up
    create_table :orders do |t|
      t.integer :user_id
      t.integer :location_id
      t.date :pickup_at
      t.string :status
      t.decimal :subTotal
      t.decimal :taxTotal
      t.decimal :total
      t.string :comment
      t.date :placed_at
      t.timestamps
    end
  end

  def self.down
    drop_table :orders
  end
end
