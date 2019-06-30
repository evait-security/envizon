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

ActiveRecord::Schema.define(version: 2018_06_13_113412) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "clients", force: :cascade do |t|
    t.string "ip", limit: 39, default: ""
    t.string "mac", limit: 17, default: ""
    t.string "hostname", default: ""
    t.string "os", default: ""
    t.string "cpe", default: ""
    t.string "icon", default: ""
    t.string "vendor", default: ""
    t.string "ostype", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "clients_groups", id: false, force: :cascade do |t|
    t.bigint "group_id", null: false
    t.bigint "client_id", null: false
  end

  create_table "clients_labels", id: false, force: :cascade do |t|
    t.bigint "label_id", null: false
    t.bigint "client_id", null: false
  end

  create_table "groups", force: :cascade do |t|
    t.string "name", default: ""
    t.string "icon", default: ""
    t.boolean "mod"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "labels", force: :cascade do |t|
    t.string "name", default: ""
    t.text "description", default: ""
    t.string "priority", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "outputs", force: :cascade do |t|
    t.bigint "client_id"
    t.bigint "port_id"
    t.string "name", default: ""
    t.string "value", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_outputs_on_client_id"
    t.index ["port_id"], name: "index_outputs_on_port_id"
  end

  create_table "ports", force: :cascade do |t|
    t.bigint "client_id"
    t.bigint "number", default: -1
    t.string "service", default: ""
    t.text "description", default: ""
    t.boolean "sv", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_ports_on_client_id"
  end

  create_table "saved_scans", force: :cascade do |t|
    t.string "name"
    t.string "parameter"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "scans", force: :cascade do |t|
    t.string "command"
    t.string "name"
    t.datetime "startdate"
    t.datetime "enddate"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status"
    t.string "file"
    t.index ["user_id"], name: "index_scans_on_user_id"
  end

  create_table "settings", force: :cascade do |t|
    t.string "name"
    t.string "value"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_settings_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username", default: "", null: false
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
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "outputs", "clients"
  add_foreign_key "outputs", "ports"
  add_foreign_key "ports", "clients"
  add_foreign_key "scans", "users"
  add_foreign_key "settings", "users"
end
