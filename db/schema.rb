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

ActiveRecord::Schema.define(version: 20150504125804) do

  create_table "badges", force: :cascade do |t|
    t.string   "name"
    t.string   "picture_file_name"
    t.integer  "picture_file_size"
    t.string   "picture_content_type"
    t.datetime "picture_updated_at"
    t.integer  "chapter_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "points"
  end

  create_table "badges_users", id: false, force: :cascade do |t|
    t.integer  "badge_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "challenge_steps", force: :cascade do |t|
    t.string   "step_text"
    t.integer  "challenge_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "challenge_tabs", force: :cascade do |t|
    t.string   "name"
    t.string   "language_name"
    t.text     "starter_code"
    t.integer  "challenge_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "challenges", force: :cascade do |t|
    t.string   "name"
    t.text     "desc"
    t.integer  "chapter_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "points"
    t.string   "slug"
  end

  add_index "challenges", ["slug"], name: "index_challenges_on_slug"

  create_table "chapters", force: :cascade do |t|
    t.string   "title"
    t.text     "desc"
    t.string   "video_file_name"
    t.integer  "video_file_size"
    t.string   "video_content_type"
    t.datetime "video_updated_at"
    t.integer  "course_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.string   "slug"
    t.string   "youtube_url"
    t.boolean  "showable_by_visitor"
  end

  add_index "chapters", ["slug"], name: "index_chapters_on_slug"

  create_table "courses", force: :cascade do |t|
    t.string   "name"
    t.text     "desc"
    t.string   "logo_file_name"
    t.integer  "logo_file_size"
    t.string   "logo_content_type"
    t.datetime "logo_updated_at"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.boolean  "published",          default: false
    t.boolean  "coming_soon",        default: true
    t.string   "slug"
    t.boolean  "is_free",            default: true
    t.string   "cover_file_name"
    t.integer  "cover_file_size"
    t.string   "cover_content_type"
    t.datetime "cover_updated_at"
  end

  add_index "courses", ["slug"], name: "index_courses_on_slug"

  create_table "courses_users", id: false, force: :cascade do |t|
    t.integer  "course_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "hints", force: :cascade do |t|
    t.string   "title"
    t.text     "desc"
    t.integer  "points"
    t.integer  "challenge_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "hints_users", id: false, force: :cascade do |t|
    t.integer "hint_id"
    t.integer "user_id"
  end

  create_table "user_solution_tabs", force: :cascade do |t|
    t.integer  "user_solution_id"
    t.text     "code"
    t.string   "name"
    t.string   "language_name"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "user_solutions", force: :cascade do |t|
    t.integer  "points"
    t.integer  "challenge_id"
    t.integer  "user_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",     null: false
    t.string   "encrypted_password",     default: "",     null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,      null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "username"
    t.string   "name"
    t.integer  "score"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "role",                   default: "user"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
