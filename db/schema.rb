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

ActiveRecord::Schema[8.0].define(version: 2026_01_16_161035) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pg_trgm"

  create_table "custom_field_values", force: :cascade do |t|
    t.bigint "post_id", null: false
    t.bigint "custom_field_id", null: false
    t.string "type", null: false
    t.json "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["custom_field_id"], name: "index_custom_field_values_on_custom_field_id"
    t.index ["post_id"], name: "index_custom_field_values_on_post_id"
  end

  create_table "custom_fields", force: :cascade do |t|
    t.string "name", null: false
    t.string "type", null: false
    t.json "options"
    t.boolean "required", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "posts", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.bigint "created_by_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["content"], name: "index_posts_on_content", opclass: :gist_trgm_ops, using: :gist
    t.index ["created_by_id"], name: "index_posts_on_created_by_id"
    t.index ["title"], name: "index_posts_on_title", opclass: :gist_trgm_ops, using: :gist
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "custom_field_values", "custom_fields"
  add_foreign_key "custom_field_values", "posts"
  add_foreign_key "posts", "users", column: "created_by_id"
end
