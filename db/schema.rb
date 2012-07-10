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

ActiveRecord::Schema.define(:version => 20120710034831) do

  create_table "clients", :force => true do |t|
    t.string   "name"
    t.string   "status"
    t.datetime "created_at",                                         :null => false
    t.datetime "updated_at",                                         :null => false
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
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
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
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.boolean  "receives_email", :default => false
    t.string   "street"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "county"
    t.string   "country"
  end

  create_table "data_vaults", :force => true do |t|
    t.integer  "data_vaultable_id"
    t.string   "data_vaultable_type"
    t.text     "encrypted_data"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  create_table "file_attachments", :force => true do |t|
    t.integer  "client_id"
    t.integer  "ticket_id"
    t.integer  "project_id"
    t.string   "attachment_file_file_name"
    t.string   "attachment_file_file_content_type"
    t.integer  "attachment_file_file_size"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.boolean  "not_valid"
  end

  create_table "git_commits", :force => true do |t|
    t.text     "payload"
    t.integer  "git_push_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "git_pushes", :force => true do |t|
    t.text     "payload"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "user_id"
  end

  create_table "github_concernable_git_pushes", :force => true do |t|
    t.string   "github_concernable_type"
    t.integer  "github_concernable_id"
    t.integer  "git_push_id"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  create_table "oauth_access_grants", :force => true do |t|
    t.integer  "resource_owner_id", :null => false
    t.integer  "application_id",    :null => false
    t.string   "token",             :null => false
    t.integer  "expires_in",        :null => false
    t.string   "redirect_uri",      :null => false
    t.datetime "created_at",        :null => false
    t.datetime "revoked_at"
    t.string   "scopes"
  end

  add_index "oauth_access_grants", ["token"], :name => "index_oauth_access_grants_on_token", :unique => true

  create_table "oauth_access_tokens", :force => true do |t|
    t.integer  "resource_owner_id"
    t.integer  "application_id",    :null => false
    t.string   "token",             :null => false
    t.string   "refresh_token"
    t.integer  "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at",        :null => false
    t.string   "scopes"
  end

  add_index "oauth_access_tokens", ["refresh_token"], :name => "index_oauth_access_tokens_on_refresh_token", :unique => true
  add_index "oauth_access_tokens", ["resource_owner_id"], :name => "index_oauth_access_tokens_on_resource_owner_id"
  add_index "oauth_access_tokens", ["token"], :name => "index_oauth_access_tokens_on_token", :unique => true

  create_table "oauth_applications", :force => true do |t|
    t.string   "name",         :null => false
    t.string   "uid",          :null => false
    t.string   "secret",       :null => false
    t.string   "redirect_uri", :null => false
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "oauth_applications", ["uid"], :name => "index_oauth_applications_on_uid", :unique => true

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.integer  "client_id"
    t.datetime "created_at",                                                            :null => false
    t.datetime "updated_at",                                                            :null => false
    t.string   "guid"
    t.decimal  "overtime_multiplier", :precision => 10, :scale => 2
    t.string   "git_repo_name"
    t.boolean  "completed",                                          :default => false
    t.string   "git_repo_url"
    t.text     "release_notes"
    t.text     "xrono_notes"
    t.string   "rate_a"
    t.string   "rate_b"
  end

  create_table "roles", :force => true do |t|
    t.string   "name",              :limit => 40
    t.string   "authorizable_type", :limit => 40
    t.integer  "authorizable_id"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "role_id"
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

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       :limit => 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "tickets", :force => true do |t|
    t.integer  "project_id"
    t.string   "priority"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",                                                        :null => false
    t.datetime "updated_at",                                                        :null => false
    t.string   "guid"
    t.string   "state"
    t.decimal  "estimated_hours", :precision => 10, :scale => 2
    t.string   "git_branch"
    t.boolean  "completed",                                      :default => false
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
    t.datetime "created_at",                                             :null => false
    t.datetime "updated_at",                                             :null => false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "middle_initial"
    t.datetime "locked_at"
    t.string   "guid"
    t.boolean  "full_width",                          :default => false
    t.integer  "daily_target_hours"
    t.boolean  "expanded_calendar"
    t.boolean  "client",                              :default => false
    t.string   "authentication_token"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "versions", :force => true do |t|
    t.string   "item_type",  :null => false
    t.integer  "item_id",    :null => false
    t.string   "event",      :null => false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], :name => "index_versions_on_item_type_and_item_id"

  create_table "work_units", :force => true do |t|
    t.text     "description"
    t.integer  "ticket_id"
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
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

  add_index "work_units", ["user_id"], :name => "index_work_units_on_user_id"

end
