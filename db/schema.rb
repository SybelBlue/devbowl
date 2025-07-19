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

ActiveRecord::Schema[8.0].define(version: 2025_07_19_035518) do
  create_table "buzzs", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "game_id", null: false
    t.integer "question_id", null: false
    t.text "answer"
    t.boolean "correct"
    t.datetime "timestamp"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_buzzs_on_game_id"
    t.index ["question_id"], name: "index_buzzs_on_question_id"
    t.index ["user_id"], name: "index_buzzs_on_user_id"
  end

  create_table "games", force: :cascade do |t|
    t.integer "room_id", null: false
    t.string "status"
    t.string "current_reader"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "current_question_id"
    t.index ["current_question_id"], name: "index_games_on_current_question_id"
    t.index ["room_id"], name: "index_games_on_room_id"
  end

  create_table "prompts", force: :cascade do |t|
    t.integer "question_id", null: false
    t.string "type"
    t.string "format"
    t.text "content"
    t.text "answer"
    t.json "answer_choices"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["question_id"], name: "index_prompts_on_question_id"
  end

  create_table "questions", force: :cascade do |t|
    t.text "title"
    t.string "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rooms", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.integer "room_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["room_id"], name: "index_users_on_room_id"
  end

  add_foreign_key "buzzs", "games"
  add_foreign_key "buzzs", "questions"
  add_foreign_key "buzzs", "users"
  add_foreign_key "games", "questions", column: "current_question_id"
  add_foreign_key "games", "rooms"
  add_foreign_key "prompts", "questions"
  add_foreign_key "users", "rooms"
end
