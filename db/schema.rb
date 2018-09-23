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

ActiveRecord::Schema.define(version: 2018_09_23_230011) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "announcements", id: :serial, force: :cascade do |t|
    t.string "heading", limit: 255
    t.text "text"
    t.integer "creator_id"
    t.integer "importance", default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "assessments", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.string "deck_id", limit: 255
    t.string "uid", limit: 255
    t.string "blend_name", limit: 255
  end

  create_table "authentications", id: :serial, force: :cascade do |t|
    t.string "user_id", limit: 255
    t.string "provider", limit: 255
    t.string "uid", limit: 255
    t.string "token", limit: 255
    t.string "token_secret", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "baggages", id: :serial, force: :cascade do |t|
    t.integer "league_id"
    t.boolean "approved"
    t.integer "approver_id"
    t.integer "partner1_id"
    t.integer "partner2_id"
    t.string "comment1", limit: 255
    t.string "comment2", limit: 255
  end

  create_table "drafted_players", id: :serial, force: :cascade do |t|
    t.integer "draft_id"
    t.integer "team_id"
    t.integer "player_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "position"
  end

  create_table "drafts", id: :serial, force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "turn", default: 1
    t.integer "league_id"
  end

  create_table "events", id: :serial, force: :cascade do |t|
    t.string "title", limit: 255
    t.string "text", limit: 255
    t.integer "field_id"
    t.integer "league_id"
    t.integer "creator_id"
    t.datetime "datetime"
  end

  create_table "fields", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.string "location", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "games", id: :serial, force: :cascade do |t|
    t.integer "team_stats1_id"
    t.integer "team_stats2_id"
    t.integer "event_id"
  end

  create_table "images", force: :cascade do |t|
    t.string "link", null: false
    t.string "src", null: false
    t.integer "creator_id", null: false
    t.integer "importance", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "leagues", id: :serial, force: :cascade do |t|
    t.string "season", limit: 255
    t.integer "year"
    t.decimal "price", default: "0.0"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal "late_price", default: "0.0"
    t.boolean "current", default: false
    t.string "state", limit: 255, default: "None"
    t.index ["current"], name: "index_leagues_on_current"
  end

  create_table "meetings", id: :serial, force: :cascade do |t|
    t.boolean "available", default: false
    t.integer "questionnaire_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "event_id", null: false
  end

  create_table "pages", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "path"
    t.text "text"
    t.integer "creator_id"
    t.integer "importance", default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payments", id: :serial, force: :cascade do |t|
    t.boolean "paid", default: false
    t.integer "registration_id"
    t.string "payer_id", limit: 255
    t.string "token", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text "setup_response"
    t.text "purchase_response"
    t.text "notify_response"
    t.string "transaction_id", limit: 255
  end

  create_table "player_awards", id: :serial, force: :cascade do |t|
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
    t.string "ideas", limit: 255
    t.integer "league_id"
  end

  create_table "player_stats", id: :serial, force: :cascade do |t|
    t.integer "team_stats_id"
    t.integer "player_id"
    t.integer "assists"
    t.integer "points"
    t.integer "goals"
  end

  create_table "questionnaires", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.string "handling", limit: 255
    t.string "cutting", limit: 255
    t.string "defense", limit: 255
    t.string "fitness", limit: 255
    t.string "injuries", limit: 255
    t.string "height", limit: 255
    t.string "teams", limit: 255
    t.boolean "cocaptain", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "comments", limit: 255
    t.boolean "handler"
    t.boolean "cutter"
    t.integer "league_id"
  end

  create_table "registrations", id: :serial, force: :cascade do |t|
    t.boolean "registered", default: false
    t.integer "user_id"
    t.integer "league_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "team_stats", id: :serial, force: :cascade do |t|
    t.integer "team_id"
    t.integer "goals"
  end

  create_table "teams", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.integer "captain_id"
    t.string "image", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "color", limit: 255
    t.integer "league_id"
    t.string "place", limit: 255
    t.integer "cocaptain_id"
  end

  create_table "teams_users", id: :serial, force: :cascade do |t|
    t.integer "team_id"
    t.integer "user_id"
    t.index ["team_id", "user_id"], name: "index_teams_users_on_team_id_and_user_id", unique: true
  end

  create_table "tentative_players", id: :serial, force: :cascade do |t|
    t.integer "player_id"
    t.string "info", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "draft_id"
    t.integer "team_id"
  end

  create_table "tokens", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.uuid "uuid", default: -> { "uuid_generate_v4()" }, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_tokens_on_user_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "first_name", limit: 255
    t.string "last_name", limit: 255
    t.string "phone_number", limit: 255
    t.string "experience", limit: 255
    t.date "birthday"
    t.string "gender", limit: 255
    t.string "shirt_size", limit: 255
    t.string "admin", limit: 255, default: "none"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
