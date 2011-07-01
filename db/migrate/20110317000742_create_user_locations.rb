class CreateUserLocations < ActiveRecord::Migration
  def self.up
    create_table :locations_users do |t|
      t.integer :user_id
      t.integer :location_id
    end
  end

  def self.down
    drop_table :locations_users
  end
end
