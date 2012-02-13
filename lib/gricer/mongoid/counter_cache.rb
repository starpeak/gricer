module Gricer
  module Mongoid # :nodoc:
    module CounterCache #:nodoc:
      extend ActiveSupport::Concern
      
      # Extend the ActiveModel with the statistics class methods.
      # @see ClassMethods
      def self.included(base)
        base.extend ClassMethods
      end
      
      module ClassMethods
      
        def counter_cache(options = {})
          return if options[:counter_cache].blank?
          
          counter_field = if options[:counter_cache].to_s != 'true'
            options[:counter_cache].to_s
          else 
            "#{options.inverse_of? ? options.inverse_of : self.name.gsub(/(.*::)/, '').downcase.pluralize }_count" 
          end

          set_callback(:create, :after) do |document|
            current_document = document
            if relation = document.send(options.name)
              relation.inc(counter_field, 1)
            end
          end

          set_callback(:destroy, :after) do |document|
            current_document = document
            if relation = document.send(options.name) && relation.class.fields.keys.include?(counter_field)
              relation.inc(counter_field, -1)
            end
          end
        end
        
        def referenced_in(name, options = {}, &block)
          counter_cache = options.delete :counter_cache
          
          characterize(name, ::Mongoid::Relations::Referenced::In, options, &block).tap do |meta|
            relate(name, meta)
            reference(meta)
            autosave(meta)
            counter_cache(meta.merge counter_cache: counter_cache)
            validates_relation(meta)
          end
        end
        alias :belongs_to_related :referenced_in
        alias :belongs_to :referenced_in
        
      end
      
    end
  end
end
