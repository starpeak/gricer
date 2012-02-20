class MongoidParentModel
  include Mongoid::Document
  
  has_many :children, class_name: 'MongoidStatModel', foreign_key: :parent_id
  
  field :version, type: String
end