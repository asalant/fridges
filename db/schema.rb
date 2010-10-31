# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20101029123531) do

  create_table "fridges", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.string   "key"
    t.integer  "user_id"
    t.string   "location"
    t.string   "email_from"
    t.string   "claim_token"
    t.integer  "view_count"
    t.integer  "notes_count"
  end

  add_index "fridges", ["key"], :name => "index_fridges_on_key"
  add_index "fridges", ["user_id"], :name => "index_fridges_on_user_id"

  create_table "notes", :force => true do |t|
    t.integer  "top"
    t.integer  "left"
    t.integer  "width"
    t.integer  "height"
    t.text     "text"
    t.integer  "fridge_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "notes", ["fridge_id"], :name => "index_notes_on_fridge_id"

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "encrypted_password",   :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "gender"
    t.string   "locale"
    t.integer  "timezone"
    t.string   "facebook_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "location"
    t.string   "role"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
