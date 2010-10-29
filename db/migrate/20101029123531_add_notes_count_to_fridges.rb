class AddNotesCountToFridges < ActiveRecord::Migration
  def self.up
    add_column :fridges, :notes_count, :integer

    Fridge.all.each { |fridge| fridge.update_attribute :notes_count, fridge.notes.count }
  end

  def self.down
    remove_column :fridges, :notes_count
  end
end
