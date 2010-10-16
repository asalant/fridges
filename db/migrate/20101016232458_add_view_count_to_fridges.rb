class AddViewCountToFridges < ActiveRecord::Migration
  def self.up
    add_column :fridges, :view_count, :integer
  end

  def self.down
    remove_column :fridges, :view_count
  end
end
