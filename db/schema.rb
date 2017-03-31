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

ActiveRecord::Schema.define(version: 20170214001745) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "admins", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string   "email",                        null: false
    t.string   "password_digest",              null: false
    t.string   "admin_type",                   null: false
    t.datetime "activated_at"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.string   "privileges",      default: [],              array: true
    t.string   "first_name",                   null: false
    t.string   "last_name",                    null: false
    t.index ["email"], name: "index_admins_on_email", unique: true, using: :btree
  end

  create_table "branches", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.decimal  "latitude",             precision: 10, scale: 6,                null: false
    t.decimal  "longitude",            precision: 10, scale: 6,                null: false
    t.string   "address",                                                      null: false
    t.boolean  "default_contact_info",                          default: true
    t.datetime "created_at",                                                   null: false
    t.datetime "updated_at",                                                   null: false
  end

  create_table "promos", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string   "name",        null: false
    t.text     "description", null: false
    t.text     "terms",       null: false
    t.integer  "stock"
    t.decimal  "price"
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "users", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string   "first_name",                null: false
    t.string   "last_name",                 null: false
    t.string   "email",                     null: false
    t.string   "password_digest",           null: false
    t.date     "birthday"
    t.string   "gender",          limit: 1
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
  end

end
