class AddEmailUniquenessIndex < ActiveRecord::Migration
  def self.up
    add_index :users, :email, :unique => true
    add_index :locations, :name, :unique => true
  end

  def self.down
    remove_index :users, :email
    remove_index :locations, :name
  end
end
