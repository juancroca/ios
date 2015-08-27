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

ActiveRecord::Schema.define(version: 20150714150212) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "courses", force: :cascade do |t|
    t.string   "name"
    t.string   "semester"
    t.string   "description"
    t.integer  "year",                default: 2015
    t.datetime "enrollment_deadline"
    t.integer  "isis_id"
    t.boolean  "visible",             default: false
    t.boolean  "closed",              default: false
    t.text     "preferences"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.text     "study_fields"
  end

  create_table "courses_skills", force: :cascade do |t|
    t.integer "course_id"
    t.integer "skill_id"
  end

  add_index "courses_skills", ["course_id"], name: "index_courses_skills_on_course_id", using: :btree
  add_index "courses_skills", ["skill_id"], name: "index_courses_skills_on_skill_id", using: :btree

  create_table "groups", force: :cascade do |t|
    t.string   "name"
    t.integer  "course_id",                    null: false
    t.string   "description"
    t.integer  "minsize"
    t.integer  "maxsize"
    t.boolean  "waiting_list"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.boolean  "mandatory",    default: false
  end

  create_table "groups_skills", force: :cascade do |t|
    t.integer "group_id"
    t.integer "skill_id"
  end

  add_index "groups_skills", ["group_id"], name: "index_groups_skills_on_group_id", using: :btree
  add_index "groups_skills", ["skill_id"], name: "index_groups_skills_on_skill_id", using: :btree

  create_table "jobs", force: :cascade do |t|
    t.integer  "course_id"
    t.boolean  "started",    default: false
    t.boolean  "completed",  default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "selected",   default: false
  end

  create_table "registrations", force: :cascade do |t|
    t.text     "friend_ids"
    t.text     "groups"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "course_id",                  null: false
    t.integer  "user_id",                    null: false
    t.string   "study_field"
    t.integer  "weight",      default: 0
    t.boolean  "active",      default: true
  end

  create_table "results", force: :cascade do |t|
    t.integer  "job_id"
    t.integer  "group_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "results", ["user_id", "job_id"], name: "index_results_on_user_id_and_job_id", unique: true, using: :btree

  create_table "skill_scores", force: :cascade do |t|
    t.integer  "registration_id"
    t.integer  "skill_id"
    t.integer  "group_id"
    t.integer  "score",           default: 0
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "skill_scores", ["group_id"], name: "index_skill_scores_on_group_id", using: :btree
  add_index "skill_scores", ["registration_id"], name: "index_skill_scores_on_registration_id", using: :btree
  add_index "skill_scores", ["skill_id"], name: "index_skill_scores_on_skill_id", using: :btree

  create_table "skills", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "skills", ["name"], name: "index_skills_on_name", using: :btree

  create_table "supervisor_courses", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "course_id",  null: false
    t.integer  "user_id",    null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.integer  "isis_id"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "email",               default: "", null: false
    t.string   "encrypted_password",  default: "", null: false
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",       default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

  add_foreign_key "registrations", "courses"
  add_foreign_key "registrations", "users"
  add_foreign_key "skill_scores", "groups"
  add_foreign_key "skill_scores", "registrations"
  add_foreign_key "skill_scores", "skills"
  add_foreign_key "supervisor_courses", "courses"
  add_foreign_key "supervisor_courses", "users"
end
