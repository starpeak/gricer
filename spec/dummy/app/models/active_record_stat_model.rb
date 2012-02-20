class ActiveRecordStatModel < ActiveRecord::Base
  include Gricer::ActiveModel::Statistics
  
  belongs_to :parent, class_name: 'ActiveRecordParentModel'
end
