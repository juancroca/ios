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

ActiveRecord::Schema.define(version: 20150615192448) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "courses", force: :cascade do |t|
    t.string   "name"
    t.string   "semester"
    t.string   "description"
    t.integer  "year"
    t.datetime "enrollment_deadline"
    t.integer  "isis_id"
    t.boolean  "visible",             default: false
    t.text     "preferences"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  create_table "groups", force: :cascade do |t|
    t.string   "name"
    t.integer  "course_id",               null: false
    t.string   "description"
    t.integer  "minsize",     default: 0
    t.integer  "maxsize",     default: 0
    t.boolean  "waitingList"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "groups_users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "group_id",   null: false
    t.integer  "user_id",    null: false
  end

  create_table "student_courses", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "course_id",  null: false
    t.integer  "user_id",    null: false
  end

  create_table "supervisor_courses", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "course_id",  null: false
    t.integer  "user_id",    null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.integer  "isis_id"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "groups_users", "groups"
  add_foreign_key "groups_users", "users"
  add_foreign_key "student_courses", "courses"
  add_foreign_key "student_courses", "users"
  add_foreign_key "supervisor_courses", "courses"
  add_foreign_key "supervisor_courses", "users"
end
