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

ActiveRecord::Schema[7.0].define(version: 2022_03_21_142229) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", precision: nil, null: false
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "client_report_parts", force: :cascade do |t|
    t.bigint "report_part_id"
    t.bigint "client_id"
    t.index ["client_id"], name: "index_client_report_parts_on_client_id"
    t.index ["report_part_id"], name: "index_client_report_parts_on_report_part_id"
  end

  create_table "clients", force: :cascade do |t|
    t.string "ip", limit: 39, default: ""
    t.string "mac", limit: 17, default: ""
    t.string "hostname", default: ""
    t.string "os", default: ""
    t.string "cpe", default: ""
    t.string "icon", default: ""
    t.string "vendor", default: ""
    t.string "ostype", default: ""
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "archived", default: false
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
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "issue_templates", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.text "rating"
    t.text "recommendation"
    t.integer "severity"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "uuid", default: 0
  end

  create_table "labels", force: :cascade do |t|
    t.string "name", default: ""
    t.text "description", default: ""
    t.string "priority", default: ""
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "methodologies", force: :cascade do |t|
    t.string "name"
    t.string "title"
    t.string "author"
    t.text "refs"
    t.text "content"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "methodology_category_id"
    t.boolean "checked", default: false
    t.bigint "methodology_book_id"
    t.index ["methodology_book_id"], name: "index_methodologies_on_methodology_book_id"
    t.index ["methodology_category_id"], name: "index_methodologies_on_methodology_category_id"
  end

  create_table "methodology_books", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "methodology_categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "methodology_placeholders", force: :cascade do |t|
    t.bigint "methodology_id"
    t.bigint "placeholder_id"
    t.index ["methodology_id"], name: "index_methodology_placeholders_on_methodology_id"
    t.index ["placeholder_id"], name: "index_methodology_placeholders_on_placeholder_id"
  end

  create_table "notes", force: :cascade do |t|
    t.text "content"
    t.string "noteable_type"
    t.bigint "noteable_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["noteable_type", "noteable_id"], name: "index_notes_on_noteable_type_and_noteable_id"
  end

  create_table "outputs", force: :cascade do |t|
    t.bigint "client_id"
    t.bigint "port_id"
    t.string "name", default: ""
    t.string "value", default: ""
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["client_id"], name: "index_outputs_on_client_id"
    t.index ["port_id"], name: "index_outputs_on_port_id"
  end

  create_table "placeholder_sets", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "placeholder_v_placeholder_s", force: :cascade do |t|
    t.bigint "placeholder_value_id"
    t.bigint "placeholder_set_id"
    t.index ["placeholder_set_id"], name: "index_placeholder_v_placeholder_s_on_placeholder_set_id"
    t.index ["placeholder_value_id"], name: "index_placeholder_v_placeholder_s_on_placeholder_value_id"
  end

  create_table "placeholder_values", force: :cascade do |t|
    t.string "content"
    t.bigint "placeholder_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["placeholder_id"], name: "index_placeholder_values_on_placeholder_id"
  end

  create_table "placeholders", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "ports", force: :cascade do |t|
    t.bigint "client_id"
    t.bigint "number", default: -1
    t.string "service", default: ""
    t.text "description", default: ""
    t.boolean "sv", default: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["client_id"], name: "index_ports_on_client_id"
  end

  create_table "report_parts", force: :cascade do |t|
    t.string "title"
    t.integer "severity"
    t.text "description"
    t.text "customtargets"
    t.text "rating"
    t.text "recommendation"
    t.string "type"
    t.integer "reportable_id"
    t.string "reportable_type"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "index"
    t.integer "uuid", default: 0
  end

  create_table "reports", force: :cascade do |t|
    t.text "summary"
    t.text "conclusion"
    t.string "logo_url"
    t.string "contact_person"
    t.string "company_name"
    t.string "street"
    t.string "postalcode"
    t.string "city"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "title"
  end

  create_table "saved_scans", force: :cascade do |t|
    t.string "name"
    t.string "parameter"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "scans", force: :cascade do |t|
    t.string "command"
    t.string "name"
    t.datetime "startdate", precision: nil
    t.datetime "enddate", precision: nil
    t.bigint "user_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "status"
    t.string "file"
    t.index ["user_id"], name: "index_scans_on_user_id"
  end

  create_table "screenshots", force: :cascade do |t|
    t.text "description"
    t.integer "order"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "report_part_id"
    t.index ["report_part_id"], name: "index_screenshots_on_report_part_id"
  end

  create_table "settings", force: :cascade do |t|
    t.string "name"
    t.string "value"
    t.bigint "user_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["user_id"], name: "index_settings_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username", default: "", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at", precision: nil
    t.datetime "last_sign_in_at", precision: nil
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "client_report_parts", "clients"
  add_foreign_key "client_report_parts", "report_parts"
  add_foreign_key "methodologies", "methodology_books"
  add_foreign_key "methodologies", "methodology_categories"
  add_foreign_key "methodology_placeholders", "methodologies"
  add_foreign_key "methodology_placeholders", "placeholders"
  add_foreign_key "outputs", "clients"
  add_foreign_key "outputs", "ports"
  add_foreign_key "placeholder_v_placeholder_s", "placeholder_sets"
  add_foreign_key "placeholder_v_placeholder_s", "placeholder_values"
  add_foreign_key "placeholder_values", "placeholders"
  add_foreign_key "ports", "clients"
  add_foreign_key "scans", "users"
  add_foreign_key "screenshots", "report_parts"
  add_foreign_key "settings", "users"
end
