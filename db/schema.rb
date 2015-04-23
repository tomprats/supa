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

ActiveRecord::Schema.define(version: 20150423044722) do

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

  create_table "baggages", force: true do |t|
    t.integer "league_id"
    t.boolean "approved"
    t.integer "approver_id"
    t.integer "partner1_id"
    t.integer "partner2_id"
    t.string  "comment1"
    t.string  "comment2"
  end

  create_table "drafted_players", force: true do |t|
    t.integer  "draft_id"
    t.integer  "team_id"
    t.integer  "player_id"
    t.integer  "round"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "drafts", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "turn",       default: 1
    t.text     "order"
    t.boolean  "snake"
    t.integer  "league_id"
  end

  create_table "events", force: true do |t|
    t.string   "title"
    t.string   "text"
    t.integer  "field_id"
    t.integer  "league_id"
    t.integer  "creator_id"
    t.datetime "datetime"
  end

  create_table "fields", force: true do |t|
    t.string   "name"
    t.string   "location"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "games", force: true do |t|
    t.integer "team_stats1_id"
    t.integer "team_stats2_id"
    t.integer "event_id"
  end

  create_table "leagues", force: true do |t|
    t.string   "season"
    t.integer  "year"
    t.decimal  "price",      default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "late_price", default: 0.0
    t.boolean  "current",    default: false
    t.string   "state",      default: "None"
  end

  add_index "leagues", ["current"], name: "index_leagues_on_current", using: :btree

  create_table "meetings", force: true do |t|
    t.datetime "datetime"
    t.boolean  "available",        default: false
    t.integer  "questionnaire_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payments", force: true do |t|
    t.boolean  "paid",              default: false
    t.integer  "registration_id"
    t.string   "payer_id"
    t.string   "token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "setup_response"
    t.text     "purchase_response"
    t.text     "notify_response"
    t.string   "transaction_id"
  end

  create_table "player_awards", force: true do |t|
    t.integer "user_id"
    t.integer "most_valuable"
    t.integer "offensive"
    t.integer "defensive"
    t.integer "rookie"
    t.integer "female"
    t.integer "comeback"
    t.integer "captain"
    t.integer "spirit"
    t.integer "iron_man"
    t.integer "most_outspoken"
    t.integer "most_improved"
    t.integer "hustle"
    t.integer "best_layouts"
    t.integer "most_underrated"
    t.integer "sportsmanship"
    t.string  "ideas"
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
    t.boolean  "cocaptain",  default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "comments"
    t.boolean  "handler"
    t.boolean  "cutter"
    t.integer  "league_id"
  end

  create_table "registrations", force: true do |t|
    t.boolean  "registered", default: false
    t.integer  "user_id"
    t.integer  "league_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "team_stats", force: true do |t|
    t.integer "team_id"
    t.integer "goals"
  end

  create_table "teams", force: true do |t|
    t.string   "name"
    t.integer  "captain_id"
    t.string   "image"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "color"
    t.integer  "league_id"
    t.string   "place"
  end

  create_table "teams_users", force: true do |t|
    t.integer "team_id"
    t.integer "user_id"
  end

  add_index "teams_users", ["team_id", "user_id"], name: "index_teams_users_on_team_id_and_user_id", unique: true, using: :btree

  create_table "tentative_players", force: true do |t|
    t.integer  "player_id"
    t.string   "info"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "draft_id"
    t.integer  "team_id"
  end

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
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
