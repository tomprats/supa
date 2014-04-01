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

ActiveRecord::Schema.define(version: 20140326031111) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "announcements", force: true do |t|
    t.string   "heading"
    t.text     "text"
    t.integer  "creator_id"
    t.integer  "importance", default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "authentications", force: true do |t|
    t.string   "user_id"
    t.string   "provider"
    t.string   "uid"
    t.string   "token"
    t.string   "token_secret"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "draft_groups", force: true do |t|
    t.string   "name"
    t.integer  "draft_id"
    t.integer  "captain_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "draft_players", force: true do |t|
    t.integer  "draft_group_id"
    t.integer  "player_id"
    t.string   "position"
    t.integer  "rating"
    t.string   "info"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "drafted_players", force: true do |t|
    t.integer  "draft_id"
    t.integer  "team_id"
    t.integer  "player_id"
    t.string   "position"
    t.integer  "round"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "drafts", force: true do |t|
    t.string   "season"
    t.integer  "year"
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "turn",       default: 1
    t.text     "order"
    t.boolean  "snake"
  end

  create_table "fields", force: true do |t|
    t.string   "name"
    t.string   "location"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "games", force: true do |t|
    t.integer  "winner_id"
    t.integer  "loser_id"
    t.integer  "creator_id"
    t.integer  "team_stats1_id"
    t.integer  "team_stats2_id"
    t.datetime "datetime"
    t.integer  "field_id"
    t.string   "name"
  end

  create_table "player_stats", force: true do |t|
    t.integer "team_stats_id"
    t.integer "player_id"
    t.integer "assists"
    t.integer "points"
    t.integer "goals"
  end

  create_table "questionnaires", force: true do |t|
    t.integer  "user_id"
    t.string   "handling"
    t.string   "cutting"
    t.string   "defense"
    t.string   "fitness"
    t.string   "injuries"
    t.string   "height"
    t.string   "teams"
    t.boolean  "cocaptain"
    t.string   "roles"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "availability"
    t.string   "comments"
  end

  create_table "team_stats", force: true do |t|
    t.integer "team_id"
    t.integer "goals"
  end

  create_table "teams", force: true do |t|
    t.string   "name"
    t.integer  "captain_id"
    t.string   "season"
    t.integer  "year"
    t.boolean  "active",     default: true
    t.string   "image"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "color"
  end

  create_table "teams_users", force: true do |t|
    t.integer "team_id"
    t.integer "user_id"
  end

  add_index "teams_users", ["team_id", "user_id"], name: "index_teams_users_on_team_id_and_user_id", unique: true, using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",     null: false
    t.string   "encrypted_password",     default: "",     null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone_number"
    t.string   "experience"
    t.date     "birthday"
    t.string   "gender"
    t.string   "shirt_size"
    t.string   "admin",                  default: "none"
    t.boolean  "active",                 default: true
    t.boolean  "spring_registered"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
