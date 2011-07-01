class CreateHoursOfOperations < ActiveRecord::Migration
  def self.up
    create_table :hours_of_operations do |t|
      t.integer :location_id
      t.string :day
      t.string :from_time
      t.string :to_time

      t.timestamps
    end
  end

  def self.down
    drop_table :hours_of_operations
  end
end
