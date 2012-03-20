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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110516074938) do

  create_table "bookmarks", :force => true do |t|
    t.integer  "user_id"
    t.integer  "film_id"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bookmarks", ["film_id"], :name => "index_bookmarks_on_film_id"
  add_index "bookmarks", ["user_id"], :name => "index_bookmarks_on_user_id"

  create_table "films", :force => true do |t|
    t.string   "title"
    t.boolean  "favorite"
    t.string   "thumbnail_url"
    t.string   "imdb_url"
    t.float    "imdb_rating"
    t.string   "country"
    t.string   "genre"
    t.text     "synopsis"
    t.string   "trailer_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "festival_url"
    t.string   "director"
    t.string   "writer"
    t.integer  "year"
    t.integer  "list_id"
  end

  add_index "films", ["list_id"], :name => "index_films_on_list_id"

  create_table "lists", :force => true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "lists", ["name"], :name => "index_lists_on_name"

  create_table "projections", :force => true do |t|
    t.datetime "showtime"
    t.string   "venue"
    t.integer  "film_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "projections", ["film_id"], :name => "index_projections_on_film_id"
  add_index "projections", ["showtime"], :name => "index_projections_on_showtime"

  create_table "users", :force => true do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "secret_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["secret_id"], :name => "index_users_on_secret_id"

end
