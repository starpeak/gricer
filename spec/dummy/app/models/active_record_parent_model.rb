class ActiveRecordParentModel < ActiveRecord::Base
  has_many :children, class_name: 'ActiveRecordStatModel', foreign_key: :parent_id
end
