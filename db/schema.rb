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

ActiveRecord::Schema[7.1].define(version: 2024_08_24_060759) do
  create_table "achievement_views", force: :cascade do |t|
    t.integer "achievement_id", null: false
    t.integer "user_id", null: false
    t.datetime "viewed_at"
    t.string "referrer"
    t.string "browser"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "ip_address"
    t.string "session_id"
    t.index ["achievement_id"], name: "index_achievement_views_on_achievement_id"
    t.index ["user_id"], name: "index_achievement_views_on_user_id"
  end

  create_table "achievements", force: :cascade do |t|
    t.string "title"
    t.date "date"
    t.text "description"
    t.string "icon"
    t.string "url"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_achievements_on_user_id"
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "daily_metrics", force: :cascade do |t|
    t.integer "user_id", null: false
    t.date "date"
    t.integer "page_views"
    t.integer "link_clicks"
    t.integer "achievement_views"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "unique_visitors"
    t.index ["user_id"], name: "index_daily_metrics_on_user_id"
  end

  create_table "link_clicks", force: :cascade do |t|
    t.integer "link_id", null: false
    t.integer "user_id", null: false
    t.datetime "clicked_at"
    t.string "referrer"
    t.string "browser"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "ip_address"
    t.string "session_id"
    t.index ["link_id"], name: "index_link_clicks_on_link_id"
    t.index ["user_id"], name: "index_link_clicks_on_user_id"
  end

  create_table "links", force: :cascade do |t|
    t.string "title"
    t.string "url"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "description"
    t.integer "position"
    t.string "icon"
    t.boolean "visible", default: true
    t.boolean "pinned", default: false
    t.index ["user_id"], name: "index_links_on_user_id"
  end

  create_table "page_views", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "path"
    t.string "referrer"
    t.string "browser"
    t.datetime "visited_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "ip_address"
    t.string "session_id"
    t.index ["user_id"], name: "index_page_views_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "avatar"
    t.string "banner"
    t.text "description"
    t.string "username"
    t.string "full_name"
    t.string "tags", default: "[]"
    t.boolean "public_analytics", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "achievement_views", "achievements"
  add_foreign_key "achievement_views", "users"
  add_foreign_key "achievements", "users"
  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "daily_metrics", "users"
  add_foreign_key "link_clicks", "links"
  add_foreign_key "link_clicks", "users"
  add_foreign_key "links", "users"
  add_foreign_key "page_views", "users"
end
