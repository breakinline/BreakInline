class AddAuthorizeNetField < ActiveRecord::Migration
  def self.up
    add_column :locations, :api_transaction_key, :string
    add_column :locations, :merchant_id, :string
  end

  def self.down
  end
end
