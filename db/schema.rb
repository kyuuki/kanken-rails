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

ActiveRecord::Schema.define(version: 20180614121445) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "app_twitter_settings", force: :cascade do |t|
    t.bigint "app_id"
    t.string "consumer_key"
    t.string "consumer_secret"
    t.string "access_token"
    t.string "access_token_secret"
    t.text "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["app_id"], name: "index_app_twitter_settings_on_app_id"
  end

  create_table "apps", force: :cascade do |t|
    t.string "name"
    t.string "identifier"
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "card_owners", force: :cascade do |t|
    t.bigint "card_id"
    t.bigint "admin_user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["admin_user_id"], name: "index_card_owners_on_admin_user_id"
    t.index ["card_id"], name: "index_card_owners_on_card_id"
  end

  create_table "cards", force: :cascade do |t|
    t.string "question"
    t.string "answer"
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "app_id"
    t.index ["app_id"], name: "index_cards_on_app_id"
  end

  create_table "clients", force: :cascade do |t|
    t.string "user_agent"
    t.string "ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "header"
  end

  create_table "log_actions", force: :cascade do |t|
    t.bigint "client_id"
    t.bigint "card_id"
    t.integer "action"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["card_id"], name: "index_log_actions_on_card_id"
    t.index ["client_id"], name: "index_log_actions_on_client_id"
  end

  add_foreign_key "app_twitter_settings", "apps"
  add_foreign_key "card_owners", "admin_users"
  add_foreign_key "card_owners", "cards"
  add_foreign_key "cards", "apps"
  add_foreign_key "log_actions", "cards"
  add_foreign_key "log_actions", "clients"
end
