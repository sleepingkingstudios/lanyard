# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_10_31_183529) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "cycles", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "slug", default: "", null: false
    t.string "year", default: "", null: false
    t.integer "season_index", null: false
    t.boolean "active", default: false, null: false
    t.boolean "ui_eligible", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["active"], name: "index_cycles_on_active", unique: true, where: "(active = true)"
    t.index ["name"], name: "index_cycles_on_name", unique: true
    t.index ["slug"], name: "index_cycles_on_slug", unique: true
    t.index ["year", "season_index"], name: "index_cycles_on_year_and_season_index", unique: true
  end

  create_table "librum_iam_credentials", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "type", null: false
    t.boolean "active", default: true, null: false
    t.jsonb "data", default: {}, null: false
    t.datetime "expires_at", precision: nil, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "user_id"
    t.index ["user_id", "type"], name: "index_librum_iam_credentials_on_user_id_and_type"
    t.index ["user_id"], name: "index_librum_iam_credentials_on_user_id"
  end

  create_table "librum_iam_users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "username", default: "", null: false
    t.string "email", default: "", null: false
    t.string "slug", default: "", null: false
    t.string "role", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_librum_iam_users_on_email", unique: true
    t.index ["slug"], name: "index_librum_iam_users_on_slug", unique: true
    t.index ["username"], name: "index_librum_iam_users_on_username", unique: true
  end

  create_table "role_events", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "type", default: "", null: false
    t.string "slug", default: "", null: false
    t.date "event_date", null: false
    t.integer "event_index", null: false
    t.jsonb "data", default: {}, null: false
    t.text "notes", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "role_id"
    t.index ["role_id", "event_index"], name: "index_role_events_on_role_id_and_event_index", unique: true
    t.index ["role_id", "slug"], name: "index_role_events_on_role_id_and_slug", unique: true
    t.index ["slug"], name: "index_role_events_on_slug", unique: true
  end

  create_table "roles", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "slug", default: "", null: false
    t.string "status", default: "new", null: false
    t.string "agency_name", default: "", null: false
    t.string "client_name", default: "", null: false
    t.string "company_name", default: "", null: false
    t.string "compensation_type", default: "unknown", null: false
    t.string "contract_type", default: "unknown", null: false
    t.string "job_title", default: "", null: false
    t.string "location_type", default: "unknown", null: false
    t.string "source", default: "unknown", null: false
    t.string "recruiter_name", default: "", null: false
    t.jsonb "data", default: {}, null: false
    t.text "notes", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "applied_at"
    t.datetime "closed_at"
    t.uuid "cycle_id"
    t.datetime "interviewing_at"
    t.datetime "offered_at"
    t.index ["cycle_id", "slug"], name: "index_roles_on_cycle_id_and_slug", unique: true
    t.index ["slug"], name: "index_roles_on_slug", unique: true
  end

  add_foreign_key "librum_iam_credentials", "librum_iam_users", column: "user_id"
end
