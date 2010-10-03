class AddKeyToFridge < ActiveRecord::Migration
  def self.up
    add_column :fridges, :key, :string

    add_index :fridges, :key

    Fridge.all.each { |f| f.reset_key! }
  end

  def self.down
    remove_column :fridges, :key
  end
end
