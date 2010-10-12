class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :gender
      t.string :locale
      t.integer :timezone
      t.string :facebook_id
      t.datetime :facebook_updated_at
      t.string :facebook_link

      t.timestamps
    end

    add_index :users, :facebook_id
    add_index :users, :email
  end

  def self.down
    drop_table :users
  end
end
