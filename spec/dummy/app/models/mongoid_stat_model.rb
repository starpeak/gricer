class MongoidStatModel
  include Mongoid::Document
  include Mongoid::Timestamps
  include Gricer::ActiveModel::Statistics
  
  belongs_to :parent, class_name: 'MongoidParentModel'
  
  field :title, type: String
end