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

ActiveRecord::Schema.define(version: 20160409011040) do

  create_table "radio_stations", force: :cascade do |t|
    t.string   "name",           limit: 255, default: "", null: false
    t.string   "url",            limit: 255, default: "", null: false
    t.string   "parse_url",      limit: 255, default: "", null: false
    t.integer  "parse_url_type", limit: 4,   default: 0,  null: false
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
  end

  create_table "radios", force: :cascade do |t|
    t.string   "name",             limit: 255, default: "", null: false
    t.string   "description",      limit: 255
    t.string   "url",              limit: 255, default: "", null: false
    t.string   "image_url",        limit: 255
    t.datetime "published_at",                              null: false
    t.integer  "radio_station_id", limit: 4
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
  end

  add_index "radios", ["name", "published_at"], name: "index_radios_on_name_and_published_at", unique: true, using: :btree

end
