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

ActiveRecord::Schema.define(version: 2021_03_11_220014) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  # These are custom enum types that must be created before they can be used in the schema definition
  create_enum "book_role_name", ["admin", "writer", "reader"]
  create_enum "register_type", ["Bank", "Card", "Investment", "Asset", "Liability", "Loan", "Institution", "Expense", "Income"]

  create_table "book_roles", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "book_id", null: false
    t.bigint "user_id", null: false
    t.enum "role", null: false, as: "book_role_name"
    t.index ["book_id", "user_id", "role"], name: "index_book_roles_on_book_id_and_user_id_and_role"
    t.index ["book_id"], name: "index_book_roles_on_book_id"
    t.index ["user_id"], name: "index_book_roles_on_user_id"
  end

  create_table "books", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name", null: false
    t.bigint "owner_id", null: false
    t.string "default_currency_iso_code", limit: 3, null: false
    t.index ["owner_id"], name: "index_books_on_owner_id"
  end

  create_table "registers", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name", null: false
    t.enum "type", null: false, as: "register_type"
    t.bigint "book_id", null: false
    t.bigint "parent_id", comment: "A null parent means it is a root register."
    t.date "starts_at", null: false
    t.string "currency_iso_code", limit: 3, null: false
    t.integer "initial_balance", default: 0, null: false
    t.boolean "active", default: true, null: false
    t.bigint "default_category_id", comment: "The category automatically selected when entering a new transaction from this register."
    t.jsonb "info", default: {}, null: false
    t.index ["book_id"], name: "index_registers_on_book_id"
    t.index ["default_category_id"], name: "index_registers_on_default_category_id"
    t.index ["parent_id"], name: "index_registers_on_parent_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "email", null: false
    t.string "encrypted_password", null: false
    t.string "display_name", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "book_roles", "books"
  add_foreign_key "book_roles", "users"
  add_foreign_key "books", "users", column: "owner_id"
  add_foreign_key "registers", "books"
  add_foreign_key "registers", "registers", column: "default_category_id"
  add_foreign_key "registers", "registers", column: "parent_id"
end
