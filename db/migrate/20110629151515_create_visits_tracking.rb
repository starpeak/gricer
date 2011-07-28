class CreateVisitsTracking < ActiveRecord::Migration
  def self.up
    create_table :sessions do |t|
      t.integer  :previous_session_id
      t.integer  :agent_id
      t.integer  :requests_count
            
      t.string   :ip_address_hash
      t.string   :domain
      t.string   :country, limit: '2'
      t.string   :region
      t.string   :city
      t.string   :postal_code
      t.float    :longitude
      t.float    :latitude
      
      t.boolean  :javascript, default: false
      t.boolean  :java
      t.string   :flash_version
      t.string   :flash_major_version
      t.string   :silverlight_version
      t.string   :silverlight_major_version
      t.integer  :screen_width
      t.integer  :screen_height
      t.string   :screen_size
      t.integer  :screen_depth
      
      t.string   :requested_locale_major, limit: '2'
      t.string   :requested_locale_minor, limit: '2'
      
      t.timestamps
    end
    
    add_index :sessions, :ip_address_hash
    add_index :sessions, :agent_id
    add_index :sessions, :country
    add_index :sessions, :city
    add_index :sessions, :javascript
    add_index :sessions, :java
    add_index :sessions, :flash_version
    add_index :sessions, :flash_major_version
    add_index :sessions, :silverlight_version
    add_index :sessions, :silverlight_major_version
    add_index :sessions, :screen_width
    add_index :sessions, :screen_height
    add_index :sessions, :screen_size
    add_index :sessions, :screen_depth
    
    
    create_table :agents do |t|
      t.integer  :requests_count
      t.integer  :sessions_count
      
      t.string   :request_header
      t.integer  :agent_class_id
      t.string   :name
      t.string   :full_version
      t.string   :major_version
      t.string   :engine_name
      t.string   :engine_version
      t.string   :os
    end
    
    add_index :agents, :request_header
    add_index :agents, :name
    add_index :agents, :major_version
    add_index :agents, :full_version
    add_index :agents, :engine_name
    add_index :agents, :engine_version
    add_index :agents, :os
    add_index :agents, :agent_class_id
    
    create_table :requests do |t|
      t.integer  :session_id
      t.integer  :agent_id

      t.string   :host
      t.string   :path
      t.string   :method
      t.string   :protocol
      
      t.string   :controller
      t.string   :action
      t.string   :format
      t.string   :param_id
      t.integer  :user_id
      
      t.integer  :status_code
      t.string   :content_type
      t.integer  :body_size
      
      t.integer  :system_time
      t.integer  :user_time
      t.integer  :total_time
      t.integer  :real_time
      
      t.boolean  :javascript
      t.integer  :window_width
      t.integer  :window_height
      
      t.string   :referer_protocol
      t.string   :referer_host
      t.string   :referer_path
      t.string   :referer_params
      
      t.string   :search_engine
      t.string   :search_query
      
      t.boolean  :is_first_in_session
      
      t.string   :locale_major, limit: 2
      t.string   :locale_minor, limit: 2
      
      t.timestamps
    end
    
    add_index :requests, :session_id
    add_index :requests, :agent_id
    add_index :requests, :path
    add_index :requests, :javascript
    add_index :requests, :window_width
    add_index :requests, :window_height
    add_index :requests, :referer_host
    add_index :requests, :search_engine
    add_index :requests, :search_query
  end

  def self.down
    remove_index :requests, :session_id
    remove_index :requests, :agent_id
    remove_index :requests, :path
    remove_index :requests, :javascript
    remove_index :requests, :window_width
    remove_index :requests, :window_height
    remove_index :requests, :referer_host
    remove_index :requests, :search_engine
    remove_index :requests, :search_query
    
    drop_table :requests
    
    remove_index :agents, :request_header
    remove_index :agents, :name
    remove_index :agents, :major_version
    remove_index :agents, :full_version
    remove_index :agents, :engine_name
    remove_index :agents, :engine_version
    remove_index :agents, :agent_class_id
    remove_index :agents, :os
    
    drop_table :agents
    
    remove_index :sessions, :ip_address_hash
    remove_index :sessions, :country
    remove_index :sessions, :city
    remove_index :sessions, :javascript
    remove_index :sessions, :java
    remove_index :sessions, :flash_version
    remove_index :sessions, :silverlight_version
    remove_index :sessions, :screen_width
    remove_index :sessions, :screen_height
    remove_index :sessions, :screen_depth
    
    
    drop_table :sessions
  end
end
