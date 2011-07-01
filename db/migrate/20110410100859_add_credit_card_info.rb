class AddCreditCardInfo < ActiveRecord::Migration
  def self.up
    rename_column :users, :lastName, :last_name
    remove_column :users, :firstName
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :address_1, :string
    add_column :users, :address_2, :string
    add_column :users, :city, :string
    add_column :users, :state, :string
    add_column :users, :postal, :string
    add_column :users, :phone, :string
    add_column :users, :card_type, :string
    add_column :users, :card_number, :string
    add_column :users, :expiration_month, :integer
    add_column :users, :expiration_year, :integer
    add_column :users, :cvv, :integer
    add_column :users, :challenge, :string
    add_column :users, :answer, :string
  end

  def self.down
  end
end
