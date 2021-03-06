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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150220211401) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "friendships", force: true do |t|
    t.integer  "left_friend_id",              null: false
    t.integer  "right_friend_id",             null: false
    t.integer  "status",          default: 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "friendships", ["left_friend_id", "right_friend_id"], name: "index_friendships_on_left_friend_id_and_right_friend_id", unique: true, using: :btree
  add_index "friendships", ["left_friend_id"], name: "index_friendships_on_left_friend_id", using: :btree
  add_index "friendships", ["right_friend_id"], name: "index_friendships_on_right_friend_id", using: :btree

  create_table "posts", force: true do |t|
    t.integer  "author_id",  null: false
    t.string   "title",      null: false
    t.text     "body",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "posts", ["author_id"], name: "index_posts_on_author_id", using: :btree

  create_table "sessions", force: true do |t|
    t.integer  "user_id",       null: false
    t.string   "session_token", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_token"], name: "index_sessions_on_session_token", unique: true, using: :btree

  create_table "users", force: true do |t|
    t.string   "first_name",                  null: false
    t.string   "last_name",                   null: false
    t.string   "email",                       null: false
    t.string   "password_digest",             null: false
    t.integer  "posts_count",     default: 0
    t.integer  "friends_count",   default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["first_name", "last_name", "email"], name: "index_users_on_first_name_and_last_name_and_email", unique: true, using: :btree
  add_index "users", ["first_name"], name: "index_users_on_first_name", using: :btree
  add_index "users", ["last_name"], name: "index_users_on_last_name", using: :btree

end
