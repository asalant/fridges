class AddEmailAttributesToFridge < ActiveRecord::Migration
  def self.up
    add_column :fridges, :email_from, :string
    add_column :fridges, :claim_token, :string
  end

  def self.down
    remove_column :fridges, :email_from
    remove_column :fridges, :claim_token
  end
end
