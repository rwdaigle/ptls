module ActiveRecord
  module Acts #:nodoc:
    module Timed #:nodoc:
      def self.included(base)
        base.extend(ClassMethods)
      end
  
      module ClassMethods
        def acts_as_timed
          
          class_eval { extend SingletonMethods }
          class_eval { include InstanceMethods }
          
          attr_reader :started_at
          
          # On save, calculate time spent
          before_validation :increment_time_spent
          
          # Convenience scope
          named_scope :timed, :conditions => ['time_spent IS NOT NULL']
        end  
      end
  
      module SingletonMethods
    
        # How much time was spent on each items' initial learning phase
        def time_spent
          self.sum(:time_spent)
        end
  
        # Get the average time spent over all timed learnings
        def avg_time_spent
          self.average(:time_spent)
        end
      end
  
      module InstanceMethods
        
        # Increment time_spent based on started_at time
        def increment_time_spent
          seconds = Time.zone.now - self.started_at if not self.started_at.blank?
          self.time_spent = (self.time_spent || 0) + (seconds || 0)
        end
        
        def started_at=(time)
          @started_at = time.is_a?(Time) ? time : Time.zone.parse(time)
        end
      end
    end
  end
end