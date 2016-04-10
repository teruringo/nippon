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

ActiveRecord::Schema.define(version: 20160410155836) do

  create_table "games", force: :cascade do |t|
    t.date     "date"
    t.string   "home_team"
    t.string   "away_team"
    t.integer  "home_gf"
    t.integer  "away_gf"
    t.string   "venue"
    t.string   "tournament"
    t.string   "lineup"
    t.string   "scorer"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "games", ["date"], name: "index_games_on_date", unique: true

  create_table "players", force: :cascade do |t|
    t.string   "name"
    t.date     "birth_day"
    t.integer  "height"
    t.integer  "weight"
    t.string   "birth_place"
    t.string   "web_site"
    t.string   "twitter"
    t.string   "facebook"
    t.string   "belongs"
    t.integer  "uniform_number"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "phonetic"
  end

end
