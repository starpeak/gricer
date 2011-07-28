module Gricer
  module ActiveModel
    module Statistics
      def self.included(base)
        base.extend ClassMethods
      end
      
      module ClassMethods
        def between(from, thru)
          #self.where(self.table_name => {:created_at.gte => from, :created_at.lt => thru})
          self.where("\"#{table_name}\".\"created_at\" >= ? AND \"#{table_name}\".\"created_at\" < ?", from, thru)
        end
        
        def between_dates(from, thru)
          self.between(from.to_date.to_time, thru.to_date.to_time+1.day)
        end
        
        def grouped_by(attribute)
          parts = attribute.to_s.split('.')
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
        end

        def count_by(attribute)
          self.grouped_by(attribute).count(:id).sort{ |a,b| b[1] <=> a[1] }
        end
      
        def filter_by(attribute, value)
          return self if attribute.blank?
          
          Rails.logger.debug "Attr: #{attribute}, Value: #{value}"
          
          parts = attribute.to_s.split('.')
          if parts[1].blank?
            self.where(attribute => value)
          else
            if association = self.reflect_on_association(parts[0].to_sym)          
              self.includes(association.name)
              .where(association.table_name => {parts[1] => value})
            else
              raise "Association '#{parts[0]}' not found on #{self.name}"
            end
          end
        end
      
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
      
        ### Examples:
        # Gricer::Request.stat('agent.name', '2011-07-05 08:00')
        # Gricer::Request.where('gricer_agents.engine_name = ?', 'Presto').stat('agent.engine_version', '2011-07-05 08:00', Time.now - 1.hour, 15.minutes)
        def stat(attribute, from, thru, step = 1.hour)
          query = self.grouped_by(attribute)
          
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
    end
  end
end
