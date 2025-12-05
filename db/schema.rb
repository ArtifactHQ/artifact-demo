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

ActiveRecord::Schema[8.0].define(version: 2025_12_05_003651) do
  create_table "documents", force: :cascade do |t|
    t.integer "project_id", null: false
    t.string "title", null: false
    t.text "content"
    t.string "document_type", default: "specification"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["document_type"], name: "index_documents_on_document_type"
    t.index ["project_id", "title"], name: "index_documents_on_project_id_and_title"
    t.index ["project_id"], name: "index_documents_on_project_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.string "status", default: "draft"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_projects_on_name"
    t.index ["status"], name: "index_projects_on_status"
  end

  create_table "versions", force: :cascade do |t|
    t.integer "document_id", null: false
    t.integer "version_number", null: false
    t.text "content"
    t.string "commit_message"
    t.datetime "committed_at"
    t.string "status", default: "draft"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["document_id", "version_number"], name: "index_versions_on_document_id_and_version_number", unique: true
    t.index ["document_id"], name: "index_versions_on_document_id"
    t.index ["status"], name: "index_versions_on_status"
  end

  add_foreign_key "documents", "projects"
  add_foreign_key "versions", "documents"
end
