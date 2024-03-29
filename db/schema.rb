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

ActiveRecord::Schema.define(:version => 20120531172525) do

  create_table "audits", :force => true do |t|
    t.integer  "job_id"
    t.integer  "user_id"
    t.string   "result"
    t.string   "note"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "change_logs", :force => true do |t|
    t.integer  "job_id"
    t.integer  "user_id"
    t.string   "from",                       :null => false
    t.string   "to",                         :null => false
    t.string   "reason"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "what",       :default => "", :null => false
  end

  create_table "jobs", :force => true do |t|
    t.integer  "project_id"
    t.string   "title",                                :null => false
    t.integer  "charge_id"
    t.integer  "user_id"
    t.integer  "expected_time"
    t.datetime "expected_start_at"
    t.text     "description"
    t.string   "type"
    t.string   "status"
    t.integer  "version_id"
    t.boolean  "closed",            :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "priority",          :default => 5
  end

  create_table "members", :force => true do |t|
    t.integer  "project_id"
    t.integer  "user_id"
    t.string   "role",                           :null => false
    t.string   "position"
    t.boolean  "should_audit", :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "preconditions", :force => true do |t|
    t.integer  "job_id"
    t.integer  "prejob_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects", :force => true do |t|
    t.integer  "user_id"
    t.string   "name",               :limit => 32,                   :null => false
    t.text     "description"
    t.boolean  "active",                           :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "current_version_id"
  end

  create_table "relavants", :force => true do |t|
    t.integer  "job_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
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

  create_table "users", :force => true do |t|
    t.string   "email",                               :default => "",   :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "",   :null => false
    t.datetime "remember_created_at"
    t.string   "authentication_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username",             :limit => 20
    t.string   "telephone",            :limit => 20
    t.string   "token",                :limit => 32
    t.boolean  "active",                              :default => true
  end

  add_index "users", ["authentication_token"], :name => "index_users_on_authentication_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

  create_table "versions", :force => true do |t|
    t.integer  "project_id"
    t.string   "version",      :null => false
    t.string   "description"
    t.datetime "start_at"
    t.datetime "end_at"
    t.text     "release_note"
    t.datetime "release_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
