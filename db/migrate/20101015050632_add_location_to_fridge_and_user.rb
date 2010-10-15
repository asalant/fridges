class AddLocationToFridgeAndUser < ActiveRecord::Migration
  def self.up
    add_column :users, :location, :string
    add_column :fridges, :location, :string
  end

  def self.down
    remove_column :users, :location
    remove_column :fridges, :location
  end
end
