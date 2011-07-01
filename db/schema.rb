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

ActiveRecord::Schema.define(:version => 20110416110449) do

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "position"
    t.integer  "location_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "choice_option_groups", :force => true do |t|
    t.string   "name"
    t.integer  "num_select"
    t.string   "description"
    t.integer  "menu_item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "choices", :force => true do |t|
    t.integer  "choice_option_group_id"
    t.string   "name"
    t.decimal  "price"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "companies", :force => true do |t|
    t.string   "name"
    t.string   "context"
    t.string   "logo"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "hours_of_operations", :force => true do |t|
    t.integer  "location_id"
    t.string   "day"
    t.string   "from"
    t.string   "to"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "locations", :force => true do |t|
    t.string   "name"
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "state"
    t.string   "postal"
    t.string   "phone"
    t.integer  "tax_rate"
    t.integer  "company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "api_transaction_key"
    t.string   "merchant_id"
  end

  create_table "locks", :force => true do |t|
    t.datetime "updated_at"
    t.datetime "created_at"
    t.text     "session_id"
    t.text     "resource"
  end

  create_table "menu_items", :force => true do |t|
    t.integer  "category_id"
    t.string   "name"
    t.string   "description"
    t.decimal  "price"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "options", :force => true do |t|
    t.integer  "choice_option_group_id"
    t.string   "name"
    t.decimal  "price"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "order_items", :force => true do |t|
    t.decimal  "option_id"
    t.decimal  "choice_id"
    t.text     "name"
    t.integer  "menu_item_id"
    t.decimal  "price"
    t.integer  "quantity"
    t.string   "comment"
    t.integer  "order_id"
    t.integer  "item_type"
    t.integer  "parent_order_item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "order_payments", :force => true do |t|
    t.text     "last_name"
    t.text     "first_name"
    t.text     "transaction_id"
    t.text     "address_2"
    t.string   "address_1"
    t.string   "city"
    t.string   "state"
    t.string   "postal"
    t.string   "phone"
    t.string   "card_type"
    t.string   "card_number"
    t.integer  "expiration_month"
    t.integer  "expiration_year"
    t.string   "auth_code"
    t.string   "order_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "orders", :force => true do |t|
    t.date     "placed_at"
    t.integer  "profile_id"
    t.integer  "location_id"
    t.date     "pickup_at"
    t.string   "status"
    t.decimal  "sub_total"
    t.decimal  "tax_total"
    t.decimal  "total"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_locations", :force => true do |t|
    t.integer  "user_id"
    t.integer  "location_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.text     "answer"
    t.text     "challenge"
    t.text     "first_name"
    t.text     "cvv"
    t.string   "email"
    t.string   "password"
    t.string   "last_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "address_1"
    t.string   "address_2"
    t.string   "city"
    t.string   "state"
    t.string   "postal"
    t.string   "phone"
    t.string   "card_type"
    t.string   "card_number"
    t.integer  "expiration_month"
    t.integer  "expiration_year"
  end

end
