module Gricer
  module ActiveRecord
    module LimitStrings
      def self.included(base)
        base.before_save :crop_strings_to_sql_limit  
      end
      
      protected
      def crop_strings_to_sql_limit
        self.class.columns.each do |column|
          if column.type == :string
            if self.send(column.name) and self.send(column.name).size > column.limit
              self.send("#{column.name}=", self.send(column.name)[0..column.limit-1])
            end
          end
        end
      end
    end
  end
end