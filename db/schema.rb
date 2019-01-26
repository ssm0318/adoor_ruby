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

ActiveRecord::Schema.define(version: 20190123033448) do

  create_table "announcements", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.datetime "published_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "answers", force: :cascade do |t|
    t.integer "author_id", null: false
    t.integer "question_id", null: false
    t.text "content", null: false
    t.string "tag_string"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_answers_on_author_id"
    t.index ["question_id"], name: "index_answers_on_question_id"
  end

  create_table "answers_tags", id: false, force: :cascade do |t|
    t.integer "answer_id", null: false
    t.integer "tag_id", null: false
    t.index ["answer_id", "tag_id"], name: "index_answers_tags_on_answer_id_and_tag_id"
    t.index ["tag_id", "answer_id"], name: "index_answers_tags_on_tag_id_and_answer_id"
  end

  create_table "assignments", force: :cascade do |t|
    t.integer "question_id", null: false
    t.integer "assigner_id", null: false
    t.integer "assignee_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assignee_id"], name: "index_assignments_on_assignee_id"
    t.index ["assigner_id"], name: "index_assignments_on_assigner_id"
    t.index ["question_id"], name: "index_assignments_on_question_id"
  end

  create_table "channels", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_channels_on_user_id"
  end

  create_table "channels_friendships", id: false, force: :cascade do |t|
    t.integer "channel_id", null: false
    t.integer "friendship_id", null: false
    t.index ["channel_id", "friendship_id"], name: "index_channels_friendships_on_channel_id_and_friendship_id"
    t.index ["friendship_id", "channel_id"], name: "index_channels_friendships_on_friendship_id_and_channel_id"
  end

  create_table "comments", force: :cascade do |t|
    t.integer "author_id", null: false
    t.integer "target_id"
    t.string "target_type"
    t.text "content", null: false
    t.boolean "secret", default: false, null: false
    t.boolean "anonymous", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_comments_on_author_id"
  end

  create_table "custom_questions", force: :cascade do |t|
    t.integer "author_id", null: false
    t.string "content", null: false
    t.string "tag_string"
    t.string "repost_message"
    t.integer "ancestor_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_custom_questions_on_author_id"
  end

  create_table "custom_questions_tags", id: false, force: :cascade do |t|
    t.integer "custom_question_id", null: false
    t.integer "tag_id", null: false
    t.index ["custom_question_id", "tag_id"], name: "index_custom_questions_tags_on_custom_question_id_and_tag_id"
    t.index ["tag_id", "custom_question_id"], name: "index_custom_questions_tags_on_tag_id_and_custom_question_id"
  end

  create_table "drawers", force: :cascade do |t|
    t.integer "user_id"
    t.integer "target_id"
    t.string "target_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "entrances", force: :cascade do |t|
    t.integer "channel_id", null: false
    t.integer "target_id"
    t.string "target_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["channel_id"], name: "index_entrances_on_channel_id"
  end

  create_table "friend_requests", force: :cascade do |t|
    t.integer "requester_id", null: false
    t.integer "requestee_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["requestee_id"], name: "index_friend_requests_on_requestee_id"
    t.index ["requester_id"], name: "index_friend_requests_on_requester_id"
  end

  create_table "friendships", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "friend_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["friend_id"], name: "index_friendships_on_friend_id"
    t.index ["user_id"], name: "index_friendships_on_user_id"
  end

  create_table "highlights", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "target_id_id"
    t.integer "target_type_id"
    t.text "content", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["target_id_id"], name: "index_highlights_on_target_id_id"
    t.index ["target_type_id"], name: "index_highlights_on_target_type_id"
    t.index ["user_id"], name: "index_highlights_on_user_id"
  end

  create_table "likes", force: :cascade do |t|
    t.integer "user_id"
    t.integer "target_id"
    t.string "target_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notifications", force: :cascade do |t|
    t.integer "recipient_id", null: false
    t.integer "actor_id"
    t.datetime "read_at"
    t.integer "target_id"
    t.string "target_type"
    t.integer "origin_id"
    t.string "origin_type"
    t.string "action"
    t.boolean "invisible", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "posts", force: :cascade do |t|
    t.integer "author_id", null: false
    t.text "content", null: false
    t.string "tag_string"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_posts_on_author_id"
  end

  create_table "posts_tags", id: false, force: :cascade do |t|
    t.integer "post_id", null: false
    t.integer "tag_id", null: false
    t.index ["post_id", "tag_id"], name: "index_posts_tags_on_post_id_and_tag_id"
    t.index ["tag_id", "post_id"], name: "index_posts_tags_on_tag_id_and_post_id"
  end

  create_table "queries", force: :cascade do |t|
    t.integer "user_id"
    t.string "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_queries_on_user_id"
  end

  create_table "questions", force: :cascade do |t|
    t.string "content", null: false
    t.boolean "official"
    t.date "selected_date"
    t.string "tag_string"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "questions_tags", id: false, force: :cascade do |t|
    t.integer "question_id", null: false
    t.integer "tag_id", null: false
    t.index ["question_id", "tag_id"], name: "index_questions_tags_on_question_id_and_tag_id"
    t.index ["tag_id", "question_id"], name: "index_questions_tags_on_tag_id_and_question_id"
  end

  create_table "replies", force: :cascade do |t|
    t.integer "author_id", null: false
    t.integer "comment_id", null: false
    t.text "content", null: false
    t.boolean "secret", default: false, null: false
    t.boolean "anonymous", null: false
    t.integer "target_author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_replies_on_author_id"
    t.index ["comment_id"], name: "index_replies_on_comment_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.string "resource_type"
    t.integer "resource_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["name"], name: "index_roles_on_name"
    t.index ["resource_type", "resource_id"], name: "index_roles_on_resource_type_and_resource_id"
  end

  create_table "tags", force: :cascade do |t|
    t.integer "author_id", null: false
    t.string "content", null: false
    t.integer "target_id"
    t.string "target_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_tags_on_author_id"
  end

  create_table "tmis", force: :cascade do |t|
    t.integer "author_id", null: false
    t.text "content", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_tmis_on_author_id"
  end

  create_table "user_queries", force: :cascade do |t|
    t.integer "user_id"
    t.string "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_queries_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "username"
    t.date "date_of_birth"
    t.string "profile"
    t.string "image"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "last_sign_in_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
    t.index ["role_id"], name: "index_users_roles_on_role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
    t.index ["user_id"], name: "index_users_roles_on_user_id"
  end

end
