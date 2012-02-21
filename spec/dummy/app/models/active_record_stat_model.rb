class ActiveRecordStatModel < ActiveRecord::Base
  include Gricer::ActiveModel::Statistics
  include Gricer::ActiveRecord::LimitStrings
  
  belongs_to :parent, class_name: 'ActiveRecordParentModel'
end
