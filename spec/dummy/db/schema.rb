# encoding: UTF-8
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

ActiveRecord::Schema.define(:version => 20110819130712) do

  create_table "active_record_parent_models", :force => true do |t|
    t.string "version"
  end

  create_table "active_record_stat_models", :force => true do |t|
    t.integer  "parent_id"
    t.string   "title"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "agents", :force => true do |t|
    t.integer "requests_count"
    t.integer "sessions_count"
    t.string  "request_header"
    t.integer "agent_class_id"
    t.string  "name"
    t.string  "full_version"
    t.string  "major_version"
    t.string  "engine_name"
    t.string  "engine_version"
    t.string  "os"
  end

  add_index "agents", ["agent_class_id"], :name => "index_agents_on_agent_class_id"
  add_index "agents", ["engine_name"], :name => "index_agents_on_engine_name"
  add_index "agents", ["engine_version"], :name => "index_agents_on_engine_version"
  add_index "agents", ["full_version"], :name => "index_agents_on_full_version"
  add_index "agents", ["major_version"], :name => "index_agents_on_major_version"
  add_index "agents", ["name"], :name => "index_agents_on_name"
  add_index "agents", ["os"], :name => "index_agents_on_os"
  add_index "agents", ["request_header"], :name => "index_agents_on_request_header"

  create_table "gricer_agents", :force => true do |t|
    t.integer "requests_count"
    t.integer "sessions_count"
    t.string  "request_header"
    t.integer "agent_class_id"
    t.string  "name"
    t.string  "full_version"
    t.string  "major_version"
    t.string  "engine_name"
    t.string  "engine_version"
    t.string  "os"
  end

  add_index "gricer_agents", ["agent_class_id"], :name => "index_gricer_agents_on_agent_class_id"
  add_index "gricer_agents", ["engine_name"], :name => "index_gricer_agents_on_engine_name"
  add_index "gricer_agents", ["engine_version"], :name => "index_gricer_agents_on_engine_version"
  add_index "gricer_agents", ["full_version"], :name => "index_gricer_agents_on_full_version"
  add_index "gricer_agents", ["major_version"], :name => "index_gricer_agents_on_major_version"
  add_index "gricer_agents", ["name"], :name => "index_gricer_agents_on_name"
  add_index "gricer_agents", ["os"], :name => "index_gricer_agents_on_os"
  add_index "gricer_agents", ["request_header"], :name => "index_gricer_agents_on_request_header"

  create_table "gricer_requests", :force => true do |t|
    t.integer  "session_id"
    t.integer  "agent_id"
    t.string   "host"
    t.string   "path"
    t.string   "method"
    t.string   "protocol"
    t.string   "controller"
    t.string   "action"
    t.string   "format"
    t.string   "param_id"
    t.integer  "user_id"
    t.integer  "status_code"
    t.string   "content_type"
    t.integer  "body_size"
    t.integer  "system_time"
    t.integer  "user_time"
    t.integer  "total_time"
    t.integer  "real_time"
    t.boolean  "javascript"
    t.integer  "window_width"
    t.integer  "window_height"
    t.string   "referer_protocol"
    t.string   "referer_host"
    t.text     "referer_path"
    t.text     "referer_params"
    t.string   "search_engine"
    t.string   "search_query"
    t.boolean  "is_first_in_session"
    t.string   "locale_major",        :limit => 2
    t.string   "locale_minor",        :limit => 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "gricer_requests", ["agent_id"], :name => "index_gricer_requests_on_agent_id"
  add_index "gricer_requests", ["javascript"], :name => "index_gricer_requests_on_javascript"
  add_index "gricer_requests", ["path"], :name => "index_gricer_requests_on_path"
  add_index "gricer_requests", ["referer_host"], :name => "index_gricer_requests_on_referer_host"
  add_index "gricer_requests", ["search_engine"], :name => "index_gricer_requests_on_search_engine"
  add_index "gricer_requests", ["search_query"], :name => "index_gricer_requests_on_search_query"
  add_index "gricer_requests", ["session_id"], :name => "index_gricer_requests_on_session_id"
  add_index "gricer_requests", ["window_height"], :name => "index_gricer_requests_on_window_height"
  add_index "gricer_requests", ["window_width"], :name => "index_gricer_requests_on_window_width"

  create_table "gricer_schema_migrations", :id => false, :force => true do |t|
    t.string "version", :null => false
  end

  add_index "gricer_schema_migrations", ["version"], :name => "gricer_unique_schema_migrations", :unique => true

  create_table "gricer_sessions", :force => true do |t|
    t.integer  "previous_session_id"
    t.integer  "agent_id"
    t.integer  "requests_count"
    t.string   "ip_address_hash"
    t.string   "domain"
    t.string   "country",                   :limit => 2
    t.string   "region"
    t.string   "city"
    t.string   "postal_code"
    t.float    "longitude"
    t.float    "latitude"
    t.boolean  "javascript",                             :default => false
    t.boolean  "java"
    t.string   "flash_version"
    t.string   "flash_major_version"
    t.string   "silverlight_version"
    t.string   "silverlight_major_version"
    t.integer  "screen_width"
    t.integer  "screen_height"
    t.string   "screen_size"
    t.integer  "screen_depth"
    t.string   "requested_locale_major",    :limit => 2
    t.string   "requested_locale_minor",    :limit => 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "gricer_sessions", ["agent_id"], :name => "index_gricer_sessions_on_agent_id"
  add_index "gricer_sessions", ["city"], :name => "index_gricer_sessions_on_city"
  add_index "gricer_sessions", ["country"], :name => "index_gricer_sessions_on_country"
  add_index "gricer_sessions", ["flash_major_version"], :name => "index_gricer_sessions_on_flash_major_version"
  add_index "gricer_sessions", ["flash_version"], :name => "index_gricer_sessions_on_flash_version"
  add_index "gricer_sessions", ["ip_address_hash"], :name => "index_gricer_sessions_on_ip_address_hash"
  add_index "gricer_sessions", ["java"], :name => "index_gricer_sessions_on_java"
  add_index "gricer_sessions", ["javascript"], :name => "index_gricer_sessions_on_javascript"
  add_index "gricer_sessions", ["screen_depth"], :name => "index_gricer_sessions_on_screen_depth"
  add_index "gricer_sessions", ["screen_height"], :name => "index_gricer_sessions_on_screen_height"
  add_index "gricer_sessions", ["screen_size"], :name => "index_gricer_sessions_on_screen_size"
  add_index "gricer_sessions", ["screen_width"], :name => "index_gricer_sessions_on_screen_width"
  add_index "gricer_sessions", ["silverlight_major_version"], :name => "index_gricer_sessions_on_silverlight_major_version"
  add_index "gricer_sessions", ["silverlight_version"], :name => "index_gricer_sessions_on_silverlight_version"

  create_table "requests", :force => true do |t|
    t.integer  "session_id"
    t.integer  "agent_id"
    t.string   "host"
    t.string   "path"
    t.string   "method"
    t.string   "protocol"
    t.string   "controller"
    t.string   "action"
    t.string   "format"
    t.string   "param_id"
    t.integer  "user_id"
    t.integer  "status_code"
    t.string   "content_type"
    t.integer  "body_size"
    t.integer  "system_time"
    t.integer  "user_time"
    t.integer  "total_time"
    t.integer  "real_time"
    t.boolean  "javascript"
    t.integer  "window_width"
    t.integer  "window_height"
    t.string   "referer_protocol"
    t.string   "referer_host"
    t.text     "referer_path"
    t.text     "referer_params"
    t.string   "search_engine"
    t.string   "search_query"
    t.boolean  "is_first_in_session"
    t.string   "locale_major",        :limit => 2
    t.string   "locale_minor",        :limit => 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "requests", ["agent_id"], :name => "index_requests_on_agent_id"
  add_index "requests", ["javascript"], :name => "index_requests_on_javascript"
  add_index "requests", ["path"], :name => "index_requests_on_path"
  add_index "requests", ["referer_host"], :name => "index_requests_on_referer_host"
  add_index "requests", ["search_engine"], :name => "index_requests_on_search_engine"
  add_index "requests", ["search_query"], :name => "index_requests_on_search_query"
  add_index "requests", ["session_id"], :name => "index_requests_on_session_id"
  add_index "requests", ["window_height"], :name => "index_requests_on_window_height"
  add_index "requests", ["window_width"], :name => "index_requests_on_window_width"

  create_table "sessions", :force => true do |t|
    t.integer  "previous_session_id"
    t.integer  "agent_id"
    t.integer  "requests_count"
    t.string   "ip_address_hash"
    t.string   "domain"
    t.string   "country",                   :limit => 2
    t.string   "region"
    t.string   "city"
    t.string   "postal_code"
    t.float    "longitude"
    t.float    "latitude"
    t.boolean  "javascript",                             :default => false
    t.boolean  "java"
    t.string   "flash_version"
    t.string   "flash_major_version"
    t.string   "silverlight_version"
    t.string   "silverlight_major_version"
    t.integer  "screen_width"
    t.integer  "screen_height"
    t.string   "screen_size"
    t.integer  "screen_depth"
    t.string   "requested_locale_major",    :limit => 2
    t.string   "requested_locale_minor",    :limit => 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["agent_id"], :name => "index_sessions_on_agent_id"
  add_index "sessions", ["city"], :name => "index_sessions_on_city"
  add_index "sessions", ["country"], :name => "index_sessions_on_country"
  add_index "sessions", ["flash_major_version"], :name => "index_sessions_on_flash_major_version"
  add_index "sessions", ["flash_version"], :name => "index_sessions_on_flash_version"
  add_index "sessions", ["ip_address_hash"], :name => "index_sessions_on_ip_address_hash"
  add_index "sessions", ["java"], :name => "index_sessions_on_java"
  add_index "sessions", ["javascript"], :name => "index_sessions_on_javascript"
  add_index "sessions", ["screen_depth"], :name => "index_sessions_on_screen_depth"
  add_index "sessions", ["screen_height"], :name => "index_sessions_on_screen_height"
  add_index "sessions", ["screen_size"], :name => "index_sessions_on_screen_size"
  add_index "sessions", ["screen_width"], :name => "index_sessions_on_screen_width"
  add_index "sessions", ["silverlight_major_version"], :name => "index_sessions_on_silverlight_major_version"
  add_index "sessions", ["silverlight_version"], :name => "index_sessions_on_silverlight_version"

end
