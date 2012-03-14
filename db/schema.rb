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

ActiveRecord::Schema.define(:version => 20120314004517) do

  create_table "associations", :force => true do |t|
    t.integer "user_id", :null => false
    t.integer "unit_id", :null => false
    t.string  "body",    :null => false
  end

  add_index "associations", ["user_id", "unit_id"], :name => "index_associations_on_user_id_and_unit_id", :unique => true

  create_table "learnings", :force => true do |t|
    t.integer  "user_id",                       :null => false
    t.integer  "unit_id",                       :null => false
    t.datetime "created_at",                    :null => false
    t.boolean  "deferred",   :default => false, :null => false
    t.float    "time_spent"
  end

  add_index "learnings", ["created_at"], :name => "index_learnings_on_created_at"
  add_index "learnings", ["unit_id"], :name => "index_learnings_on_unit_id"
  add_index "learnings", ["user_id"], :name => "index_learnings_on_user_id"

  create_table "queue_classic_jobs", :force => true do |t|
    t.text     "details"
    t.datetime "locked_at"
  end

  create_table "reviews", :force => true do |t|
    t.integer  "user_id",                         :null => false
    t.integer  "unit_id",                         :null => false
    t.integer  "interval",     :default => 1,     :null => false
    t.boolean  "success",      :default => false, :null => false
    t.boolean  "reviewed",     :default => false, :null => false
    t.datetime "scheduled_at",                    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "reviewed_at"
    t.float    "time_spent"
  end

  add_index "reviews", ["reviewed"], :name => "index_reviews_on_reviewed"
  add_index "reviews", ["reviewed_at"], :name => "index_reviews_on_reviewed_at"
  add_index "reviews", ["scheduled_at"], :name => "index_reviews_on_scheduled_at"
  add_index "reviews", ["success"], :name => "index_reviews_on_success"
  add_index "reviews", ["unit_id"], :name => "index_reviews_on_unit_id"
  add_index "reviews", ["user_id"], :name => "index_reviews_on_user_id"

  create_table "subjects", :force => true do |t|
    t.string   "permalink",           :null => false
    t.string   "from"
    t.string   "to"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title",               :null => false
    t.integer  "owner_id"
    t.string   "unit_processor_type"
  end

  add_index "subjects", ["owner_id"], :name => "index_subjects_on_owner_id"
  add_index "subjects", ["permalink"], :name => "index_subjects_on_permalink"

  create_table "units", :force => true do |t|
    t.string   "question",   :null => false
    t.string   "answer"
    t.integer  "subject_id", :null => false
    t.integer  "position",   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "units", ["position"], :name => "index_units_on_position"
  add_index "units", ["subject_id"], :name => "index_units_on_subject_id"

  create_table "users", :force => true do |t|
    t.string   "login",                     :limit => 40,                                           :null => false
    t.string   "crypted_password",          :limit => 40,                                           :null => false
    t.string   "salt",                      :limit => 40,                                           :null => false
    t.string   "email"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.integer  "daily_units",                             :default => 5,                            :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "time_zone",                               :default => "Eastern Time (US & Canada)"
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

end
