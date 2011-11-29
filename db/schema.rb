# encoding: UTF-8
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

ActiveRecord::Schema.define(:version => 20110927192744) do

  create_table "audits", :force => true do |t|
    t.integer  "auditable_id"
    t.string   "auditable_type"
    t.integer  "associated_id"
    t.string   "associated_type"
    t.integer  "user_id"
    t.string   "user_type"
    t.string   "username"
    t.string   "action"
    t.text     "audited_changes"
    t.integer  "version",         :default => 0
    t.string   "comment"
    t.string   "remote_address"
    t.datetime "created_at"
  end

  add_index "audits", ["associated_id", "associated_type"], :name => "associated_index"
  add_index "audits", ["auditable_id", "auditable_type"], :name => "auditable_index"
  add_index "audits", ["created_at"], :name => "index_audits_on_created_at"
  add_index "audits", ["user_id", "user_type"], :name => "user_index"

  create_table "clients", :force => true do |t|
    t.string   "name"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "guid"
    t.string   "initials"
    t.decimal  "overtime_multiplier", :precision => 10, :scale => 2
  end

  create_table "comments", :force => true do |t|
    t.string   "title",            :limit => 50, :default => ""
    t.text     "comment"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active"
  end

  add_index "comments", ["commentable_id"], :name => "index_comments_on_commentable_id"
  add_index "comments", ["commentable_type"], :name => "index_comments_on_commentable_type"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "contacts", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email_address"
    t.string   "phone_number"
    t.integer  "client_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "receives_email", :default => false
    t.string   "street"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "county"
    t.string   "country"
  end

  create_table "file_attachments", :force => true do |t|
    t.integer  "client_id"
    t.integer  "ticket_id"
    t.integer  "project_id"
    t.string   "attachment_file_file_name"
    t.string   "attachment_file_file_content_type"
    t.integer  "attachment_file_file_size"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "not_valid"
  end

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.integer  "client_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "guid"
    t.decimal  "overtime_multiplier", :precision => 10, :scale => 2
  end

  create_table "roles", :force => true do |t|
    t.string   "name",              :limit => 40
    t.string   "authorizable_type", :limit => 40
    t.integer  "authorizable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "site_settings", :force => true do |t|
    t.decimal  "overtime_multiplier",       :precision => 10, :scale => 2
    t.string   "site_logo_file_name"
    t.string   "site_logo_content_type"
    t.integer  "site_logo_file_size"
    t.datetime "site_logo_updated_at"
    t.decimal  "total_yearly_pto_per_user", :precision => 10, :scale => 2
    t.integer  "client_id"
  end

  create_table "tickets", :force => true do |t|
    t.integer  "project_id"
    t.string   "priority"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "guid"
    t.string   "state"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                               :default => "",    :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "",    :null => false
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "middle_initial"
    t.datetime "locked_at"
    t.string   "guid"
    t.boolean  "full_width",                          :default => false
    t.integer  "daily_target_hours"
    t.boolean  "expanded_calendar"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "work_units", :force => true do |t|
    t.text     "description"
    t.integer  "ticket_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "hours",           :precision => 10, :scale => 2
    t.boolean  "overtime"
    t.datetime "scheduled_at"
    t.string   "guid"
    t.integer  "user_id"
    t.string   "paid"
    t.string   "invoiced"
    t.datetime "invoiced_at"
    t.datetime "paid_at"
    t.string   "hours_type"
    t.decimal  "effective_hours", :precision => 10, :scale => 2
  end

end
