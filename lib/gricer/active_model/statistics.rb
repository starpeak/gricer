module Gricer
  # Gricer's ActiveModel enhancements
  module ActiveModel
    # Gricer's statistics enhancements for ActiveModel
    #
    # To add statistics to an ActiveRecord just include the module:
    #   class SomeDataModel < ::ActiveRecord::Base
    #     include ActiveModel::Statistics
    #     [...]
    #   end
    #
    # This module provides two major enhancements:
    #
    # == Extendend attribute names
    #
    # You can use relation attributes by using a dot in your attribute name.
    #
    # *Example:*
    #
    # For getting the name of the attribute name of Agent associated to the Request:
    #   Gricer::Request.human_attributes('agent.name')
    #
    # == Statistics functions and filters
    #
    # Methods for filtering, grouping, and counting records
    module Statistics
      # Extend the ActiveModel with the statistics class methods.
      # @see ClassMethods
      def self.included(base)
        base.extend ClassMethods
      end
        
      # Gricer's statistics enhancements for ActiveModel
      #
      # == Extended attribute names
      # You can use relation attributes by using a dot in your attribute name.
      #
      # @example For getting the name of the attribute name of Agent associated to the Request:
      #   Gricer::Request.human_attributes('agent.name')
      module ClassMethods
        # Find out which model type is used in this class
        def is_active_record?
          self.superclass == ::ActiveRecord::Base
        end        
        
        def model_type
          if is_active_record?
            :ActiveRecord
          else
            :Mongoid
          end
        end
        
        # Filter records for the time between from and thru
        # @param from [Date, Time] Only get records on or after this point of time
        # @param thru [Date, Time] Only get records before this point of time
        # @return [ActiveRecord::Relation/Mongoid::Criteria]      
        def between(from, thru)
          if self.is_active_record?
            self.where("\"#{table_name}\".\"created_at\" >= ? AND \"#{table_name}\".\"created_at\" < ?", from, thru)
          else
            self.where(:created_at.gte => from, :created_at.lt => thru)
          end
        end
        
        # Filter records for the dates between from and thru
        # @param from [Date] Only get records on or after this date
        # @param thru [Date] Only get records on or before this date
        # @return [ActiveRecord::Relation/Mongoid::Criteria]        
        def between_dates(from, thru)
          self.between(from.to_date.to_time, thru.to_date.to_time+1.day)
        end
        
        # Group records by attribute.
        # 
        # @param attribute [String, Symbol] Attribute to group the records for. You can use gricers extended attribute names.
        # @return [ActiveRecord::Relation] 
        def grouped_by(attribute)
          parts = attribute.to_s.split('.')
          
          if self.is_active_record?
            if parts[1].blank?
              self.group(attribute)
              .select(attribute)
            else
              if association = self.reflect_on_association(parts[0].to_sym)          
                self.includes(association.name)
                .group("\"#{association.table_name}\".\"#{parts[1]}\"")
                .select("\"#{association.table_name}\".\"#{parts[1]}\"")
              else
                raise "Association '#{parts[0]}' not found on #{self.name}"
              end
            end
          else 
            
            raise "grouped_by not yet implemented for #{model_type}"
                
          end
        end        

        # Count records by attribute.
        # 
        # @param attribute [String, Symbol] Attribute name to count for. You can use gricers extended attribute names.
        # @return [Array] 
        def count_by(attribute)
          parts = attribute.to_s.split('.')
          
          if self.is_active_record?
            self.grouped_by(attribute).count(:id).sort{ |a,b| b[1] <=> a[1] }
          else
            results = {}
            
            if parts[1].blank?
              scoped.each do |item|
                value = item.send(attribute)
                results[value] ||= 0
                results[value] += 1
              end
            else
              if association = self.reflect_on_association(parts[0].to_sym)          
                scoped.each do |item|
                  if item.send(association.name).nil?
                    value = nil
                  else
                    value = item.send(association.name).send(parts[1])
                  end
                  
                  results[value] ||= 0
                  results[value] += 1
                end
              else
                raise "Association '#{parts[0]}' not found on #{self.name}"
              end
            end
            
            results.map{ |a,b| [a,b] }.sort{ |a,b| b[1] <=> a[1] }
          end
        end
      
        # Filter records by attribute's value.
        # 
        # @example
        #   some_relation.filter('agent.name', 'Internet Explorer').filter('agent.os', 'Windows')
        # @param attribute [String, Symbol] Attribute name to filter. You can use gricers extended attribute names. 
        # @param value Attribute value to filter.
        # @return [ActiveRecord::Relation/Mongoid::Criteria] 

        def filter_by(attribute, value)
          return self if attribute.blank?
          
          #Rails.logger.debug "Attr: #{attribute}, Value: #{value}"
          
          parts = attribute.to_s.split('.')
          if parts[1].blank?
            self.where(attribute => value)
          else
            if association = self.reflect_on_association(parts[0].to_sym)   
              case model_type
                when :ActiveRecord 
                  self.includes(association.name)
                  .where(association.table_name => {parts[1] => value})
                when :Mongoid
                  any_in association.key => association.class_name.constantize.where(parts[1] => value).only(:id).map{|x| x.id}
                else
                  raise "Model type '#{model_type}' is not defined for filter_by in Gricer::ActiveModel::Statistics"
              end
            else
              raise "Association '#{parts[0]}' not found on #{self.name}"
            end
          end
        end
        
        # Filter out records with nil value in given attribute
        #
        # @example
        #   some_relation.without_nil_in('name')
        # @param attribute [String, Symbol] Attribute name to filter.
        # @return [ActiveRecord::Relation/Mongoid::Criteria] 
        def without_nil_in(attribute, options = {})
          if model_type == :Mongoid
            excludes(attribute => nil)
          else
            where("#{attribute} IS NOT NULL")
          end
        end
      
        # Extends ActiveModel::Translation#human_attribute_name to use Gricer's extended attribute names.
        #
        # @param attribute [String, Symbol] Attribute name to get human name for. You can use gricers extended attribute names. 
        # @param options [Hash] See ActiveModel::Translation for possible options.
        # @return [String]
        def human_attribute_name(attribute, options = {})
          parts = attribute.to_s.split('.')
          if parts[1].blank?
            super attribute, options
          else
            if association = self.reflect_on_association(parts[0].to_sym)
              association.active_record.human_attribute_name parts[1], options
            else
              parts[1].to_s.humanize
            end
          end
          
        end
        
        # Return hash for values of an attribute within the given time
        #
        #
        # @example Get agent.name statistics for 2011-07-05 08:00 until 2011-07-06 08:00
        #   Gricer::Request.stat('agent.name', '2011-07-05 08:00', '2011-07-06 08:00')
        # @example Get agent.engine_version statistics for agents with engine_name = 'Presto' and values between 2011-07-05 08:00 and last hour with values in 15 minutes steps
        #   Gricer::Request.where('gricer_agents.engine_name = ?', 'Presto').stat('agent.engine_version', '2011-07-05 08:00', Time.now - 1.hour, 15.minutes)
        #
        # @param attribute [String, Symbol] Attribute name to get data for. You can use gricers extended attribute names. 
        # @param from [Date, Time] Only get records on or after this point of time
        # @param thru [Date, Time] Only get records before this point of time
        # @param step [Integer] Time interval for grouping values
        # @return [Hash]
        def stat(attribute, from, thru, step = 1.hour)
          #query = self.grouped_by(attribute)
          
          from = from.to_date.to_time
          thru = thru.to_date.to_time+1.day

          now = from

          stats = {}

          while now < thru do
            self.between(now, now + step).count_by(attribute).each do |value|
              stats[value[0]] ||= []
              stats[value[0]] << [now.to_i*1000, value[1]]
            end
            now += step
          end
        
          return stats
        end
      end
      
      def model_type
        self.class.model_type
      end
      
      
    end
  end
end
