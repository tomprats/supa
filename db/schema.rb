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

ActiveRecord::Schema.define(version: 20160815230659) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "announcements", force: :cascade do |t|
    t.string   "heading"
    t.text     "text"
    t.integer  "creator_id"
    t.integer  "importance", default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "assessments", force: :cascade do |t|
    t.integer "user_id"
    t.string  "deck_id"
    t.string  "uid"
    t.string  "blend_name"
  end

  create_table "authentications", force: :cascade do |t|
    t.string   "user_id"
    t.string   "provider"
    t.string   "uid"
    t.string   "token"
    t.string   "token_secret"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "baggages", force: :cascade do |t|
    t.integer "league_id"
    t.boolean "approved"
    t.integer "approver_id"
    t.integer "partner1_id"
    t.integer "partner2_id"
    t.string  "comment1"
    t.string  "comment2"
  end

  create_table "drafted_players", force: :cascade do |t|
    t.integer  "draft_id"
    t.integer  "team_id"
    t.integer  "player_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
  end

  create_table "drafts", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "turn",       default: 1
    t.integer  "league_id"
  end

  create_table "events", force: :cascade do |t|
    t.string   "title"
    t.string   "text"
    t.integer  "field_id"
    t.integer  "league_id"
    t.integer  "creator_id"
    t.datetime "datetime"
  end

  create_table "fields", force: :cascade do |t|
    t.string   "name"
    t.string   "location"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "games", force: :cascade do |t|
    t.integer "team_stats1_id"
    t.integer "team_stats2_id"
    t.integer "event_id"
  end

  create_table "leagues", force: :cascade do |t|
    t.string   "season"
    t.integer  "year"
    t.decimal  "price",      default: "0.0"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "late_price", default: "0.0"
    t.boolean  "current",    default: false
    t.string   "state",      default: "None"
    t.index ["current"], name: "index_leagues_on_current", using: :btree
  end

  create_table "meetings", force: :cascade do |t|
    t.datetime "datetime"
    t.boolean  "available",        default: false
    t.integer  "questionnaire_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pages", force: :cascade do |t|
    t.string   "name"
    t.string   "path"
    t.text     "text"
    t.integer  "creator_id"
    t.integer  "importance", default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payments", force: :cascade do |t|
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

  create_table "player_awards", force: :cascade do |t|
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
    t.integer "league_id"
  end

  create_table "player_stats", force: :cascade do |t|
    t.integer "team_stats_id"
    t.integer "player_id"
    t.integer "assists"
    t.integer "points"
    t.integer "goals"
  end

  create_table "questionnaires", force: :cascade do |t|
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

  create_table "registrations", force: :cascade do |t|
    t.boolean  "registered", default: false
    t.integer  "user_id"
    t.integer  "league_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "team_stats", force: :cascade do |t|
    t.integer "team_id"
    t.integer "goals"
  end

  create_table "teams", force: :cascade do |t|
    t.string   "name"
    t.integer  "captain_id"
    t.string   "image"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "color"
    t.integer  "league_id"
    t.string   "place"
    t.integer  "cocaptain_id"
  end

  create_table "teams_users", force: :cascade do |t|
    t.integer "team_id"
    t.integer "user_id"
    t.index ["team_id", "user_id"], name: "index_teams_users_on_team_id_and_user_id", unique: true, using: :btree
  end

  create_table "tentative_players", force: :cascade do |t|
    t.integer  "player_id"
    t.string   "info"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "draft_id"
    t.integer  "team_id"
  end

  create_table "tokens", force: :cascade do |t|
    t.integer  "user_id",                                          null: false
    t.uuid     "uuid",       default: -> { "uuid_generate_v4()" }, null: false
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
    t.index ["user_id"], name: "index_tokens_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                            null: false
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone_number"
    t.string   "experience"
    t.date     "birthday"
    t.string   "gender"
    t.string   "shirt_size"
    t.string   "admin",           default: "none"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
  end

end
