class DeviseCreateUsers < ActiveRecord::Migration
  def self.up
    drop_table :users

    create_table(:users) do |t|
      t.database_authenticatable :null => false
      t.recoverable
      t.rememberable
      t.trackable

      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :gender
      t.string :locale
      t.integer :timezone
      t.string :facebook_id

      t.timestamps
    end

    add_index :users, :email,                :unique => true
    add_index :users, :reset_password_token, :unique => true
  end

  def self.down
    drop_table :users
  end
end
