# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_03_08_110332) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "bank_accounts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "bank_name"
    t.string "account_number"
  end

  create_table "book_roles", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.uuid "book_id", null: false
    t.uuid "user_id", null: false
    t.string "role", null: false
    t.index ["book_id", "user_id"], name: "index_book_roles_on_book_id_and_user_id", unique: true
    t.index ["book_id"], name: "index_book_roles_on_book_id"
    t.index ["user_id"], name: "index_book_roles_on_user_id"
  end

  create_table "books", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name", null: false
    t.uuid "owner_id", null: false
    t.string "default_currency_iso_code"
    t.index ["name", "owner_id"], name: "index_books_on_name_and_owner_id", unique: true
    t.index ["owner_id"], name: "index_books_on_owner_id"
  end

  create_table "credit_cards", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "card_number"
    t.datetime "expires_at"
    t.integer "limit"
  end

  create_table "registers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.uuid "book_id", null: false
    t.string "name"
    t.integer "initial_balance"
    t.string "registerable_type"
    t.uuid "registerable_id"
    t.index ["book_id"], name: "index_registers_on_book_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "email", null: false
    t.string "display_name", null: false
    t.string "password_digest", null: false
    t.index ["display_name"], name: "index_users_on_display_name"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "book_roles", "books"
  add_foreign_key "book_roles", "users"
  add_foreign_key "books", "users", column: "owner_id"
  add_foreign_key "registers", "books"
end
