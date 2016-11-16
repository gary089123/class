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

ActiveRecord::Schema.define(version: 20161116030642) do

  create_table "rent_times", force: :cascade do |t|
    t.integer  "rent_id",    limit: 4
    t.datetime "start"
    t.datetime "end"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "rent_times", ["rent_id"], name: "index_rent_times_on_rent_id", using: :btree

  create_table "rents", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.integer  "facility",    limit: 4
    t.datetime "start"
    t.datetime "end"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "user_id",     limit: 4
    t.string   "status",      limit: 255
    t.integer  "apid",        limit: 4
    t.integer  "semester_id", limit: 4
    t.string   "teacher",     limit: 255
    t.string   "phone",       limit: 255
    t.string   "email",       limit: 255
  end

  add_index "rents", ["semester_id"], name: "index_rents_on_semester_id", using: :btree
  add_index "rents", ["user_id"], name: "index_rents_on_user_id", using: :btree

  create_table "semesters", force: :cascade do |t|
    t.integer  "name",        limit: 4
    t.integer  "updown",      limit: 4
    t.string   "description", limit: 255
    t.boolean  "is_open"
    t.datetime "start"
    t.datetime "end"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "srent_times", force: :cascade do |t|
    t.integer  "srent_id",   limit: 4
    t.datetime "start"
    t.datetime "end"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "class",      limit: 255
  end

  add_index "srent_times", ["srent_id"], name: "index_srent_times_on_srent_id", using: :btree

  create_table "srents", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.integer  "facility",    limit: 4
    t.date     "startd"
    t.date     "endd"
    t.string   "classes",     limit: 255
    t.integer  "amount",      limit: 4
    t.string   "status",      limit: 255
    t.integer  "user_id",     limit: 4
    t.string   "teacher",     limit: 255
    t.string   "phone",       limit: 255
    t.string   "email",       limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "semester_id", limit: 4
    t.integer  "apid",        limit: 4
  end

  add_index "srents", ["semester_id"], name: "index_srents_on_semester_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.integer  "idnumber",   limit: 4
    t.string   "name",       limit: 255
    t.string   "unit",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "privilege",  limit: 4
  end

end
