class CreateStatTestModels < ActiveRecord::Migration
  def change
    create_table :active_record_stat_models, force: true do |t|
      t.references :parent
      t.string  :title
      t.string  :country, limit: 2
      t.timestamps
    end 

    create_table :active_record_parent_models, force: true do |t|
      t.string  :version
    end 
  end
end