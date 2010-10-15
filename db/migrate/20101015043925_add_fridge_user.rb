class AddFridgeUser < ActiveRecord::Migration
  def self.up
    add_column :fridges, :user_id, :integer
    add_index :fridges, :user_id
  end

  def self.down
    remove_index :fridges, :user_id
    remove_column :fridges, :user_id
  end
end
