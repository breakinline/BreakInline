class CreateOrderPayments < ActiveRecord::Migration
  def self.up
    create_table :order_payments do |t|
      t.string :address_1
      t.string :address_2
      t.string :city
      t.string :state
      t.string :postal
      t.string :phone
      t.string :card_type
      t.string :card_number
      t.integer :expiration_month
      t.integer :expiration_year
      t.string :auth_code
      t.string :transaction_id
      t.string :order_id
      t.string :first_name
      t.string :last_name
      t.timestamps
    end
  end

  def self.down
    drop_table :order_payments
  end
end
