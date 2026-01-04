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

ActiveRecord::Schema[8.0].define(version: 2026_01_04_202355) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "menu_items", force: :cascade do |t|
    t.bigint "section_id", null: false
    t.string "name", null: false
    t.text "description"
    t.decimal "price", precision: 10, scale: 2
    t.integer "position", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "content_locale", default: "en"
    t.index ["section_id"], name: "index_menu_items_on_section_id"
  end

  create_table "menus", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.string "content_locale", default: "en"
    t.index ["user_id"], name: "index_menus_on_user_id"
  end

  create_table "sections", force: :cascade do |t|
    t.bigint "menu_id", null: false
    t.string "name", null: false
    t.text "description"
    t.integer "position", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "content_locale", default: "en"
    t.index ["menu_id"], name: "index_sections_on_menu_id"
  end

  create_table "translations", force: :cascade do |t|
    t.string "translatable_type", null: false
    t.bigint "translatable_id", null: false
    t.string "field_name", null: false
    t.string "locale", null: false
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["translatable_type", "translatable_id", "field_name", "locale"], name: "index_translations_on_translatable_and_field_and_locale", unique: true
    t.index ["translatable_type", "translatable_id"], name: "index_translations_on_translatable"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "menu_items", "sections"
  add_foreign_key "menus", "users"
  add_foreign_key "sections", "menus"
end
