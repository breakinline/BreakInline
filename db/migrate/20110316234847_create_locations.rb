class CreateLocations < ActiveRecord::Migration
  def self.up
    create_table :locations do |t|
      t.string :name
      t.string :address1
      t.string :address2
      t.string :city
      t.string :state
      t.string :postal
      t.string :phone
      t.integer :taxRate
      t.integer :company_id
      t.integer :show_delivery
      t.integer :delivery_increment
      t.integer :delivery_padding
      t.timestamps
    end
  end

  def self.down
    drop_table :locations
  end
end
