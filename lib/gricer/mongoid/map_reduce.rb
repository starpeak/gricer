module Gricer
  module Mongoid
    module MapReduce 
      
      extend ActiveSupport::Concern
      
      # Extend the ActiveModel with the statistics class methods.
      # @see ClassMethods
      def self.included(base)
        base.extend ClassMethods
      end
      
      module ClassMethods
        def map_reduce(map, reduce, options = {}) 
          options = {:out => {:inline => 1}, :raw => true, :query => criteria.selector}.merge(options) 
          collection.map_reduce(map, reduce, options) 
        end 
      end
    end
  end
end