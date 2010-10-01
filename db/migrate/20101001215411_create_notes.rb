class CreateNotes < ActiveRecord::Migration
  def self.up
    create_table :notes do |t|
      t.integer :top
      t.integer :left
      t.integer :width
      t.integer :height
      t.text :text
      t.references :fridge

      t.timestamps
    end

    add_index :notes, :fridge_id
  end

  def self.down
    drop_table :notes
  end
end
