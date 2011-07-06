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

ActiveRecord::Schema.define(:version => 20110706012009) do

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "position"
    t.integer  "location_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categories", ["location_id"], :name => "index_categories_on_location_id"
  add_index "categories", ["position"], :name => "index_categories_on_position"

  create_table "choice_option_groups", :force => true do |t|
    t.integer  "item_type"
    t.integer  "position"
    t.string   "name"
    t.integer  "max_quantity"
    t.string   "description"
    t.integer  "menu_item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "choice_option_groups", ["menu_item_id"], :name => "index_choice_option_groups_on_menu_item_id"
  add_index "choice_option_groups", ["position"], :name => "index_choice_option_groups_on_position"

  create_table "choice_options", :force => true do |t|
    t.integer  "choice_option_group_id"
    t.string   "name"
    t.decimal  "price"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "choice_options", ["choice_option_group_id"], :name => "index_choice_options_on_choice_option_group_id"
  add_index "choice_options", ["position"], :name => "index_choice_options_on_position"

  create_table "companies", :force => true do |t|
    t.string   "name"
    t.string   "context"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "hours_of_operations", :force => true do |t|
    t.decimal  "location_id"
    t.decimal  "day"
    t.text     "from_time"
    t.text     "to_time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "hours_of_operations", ["location_id"], :name => "index_hours_of_operations_on_location_id"

  create_table "locations", :force => true do |t|
    t.text     "context"
    t.decimal  "delivery_increment"
    t.decimal  "delivery_padding"
    t.decimal  "show_delivery"
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

  add_index "locations", ["company_id"], :name => "index_locations_on_company_id"

  create_table "locations_users", :id => false, :force => true do |t|
    t.integer  "user_id"
    t.integer  "location_id"
    t.datetime "updated_at"
    t.datetime "created_at"
  end

  add_index "locations_users", ["location_id"], :name => "index_locations_users_on_location_id"
  add_index "locations_users", ["user_id"], :name => "index_locations_users_on_user_id"

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

  add_index "menu_items", ["category_id"], :name => "index_menu_items_on_category_id"
  add_index "menu_items", ["position"], :name => "index_menu_items_on_position"

  create_table "order_items", :force => true do |t|
    t.text     "item_for"
    t.decimal  "choice_option_id"
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

  add_index "order_items", ["choice_option_id"], :name => "index_order_items_on_choice_option_id"
  add_index "order_items", ["menu_item_id"], :name => "index_order_items_on_menu_item_id"
  add_index "order_items", ["order_id"], :name => "index_order_items_on_order_id"
  add_index "order_items", ["parent_order_item_id"], :name => "index_order_items_on_parent_order_item_id"

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

  add_index "order_payments", ["order_id"], :name => "index_order_payments_on_order_id"

  create_table "orders", :force => true do |t|
    t.date     "placed_at"
    t.integer  "user_id"
    t.integer  "location_id"
    t.date     "pickup_at"
    t.string   "status"
    t.decimal  "sub_total"
    t.decimal  "tax_total"
    t.decimal  "total"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "orders", ["location_id"], :name => "index_orders_on_location_id"
  add_index "orders", ["user_id"], :name => "index_orders_on_user_id"

  create_table "users", :force => true do |t|
    t.text     "role"
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
