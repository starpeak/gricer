class RefererPathAsText < ActiveRecord::Migration
  def up
    change_column :requests, :referer_path, :text, limit: nil
  end

  def down
    change_column :requests, :referer_path, :string, limit: 255
  end
end
