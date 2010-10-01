class CreateFridges < ActiveRecord::Migration
  def self.up
    create_table :fridges do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :fridges
  end
end
