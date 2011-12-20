module Ptls
  module User
    module Learning
  
      # Have I started learning this subject yet?
      def started?(subject)
        learnings.for(subject).not_deferred.count > 0    
      end
  
      # Do I have anything to learn today for this subject?
      def learn?(subject)
        items_left_to_learn_for(subject) > 0 && !next_unit_to_learn_for(subject).nil?
      end
  
      # What items have I learned today for this subject
      def learnings_for(subject)
        learnings.for(subject).today.not_deferred
      end
  
      # How many items have I learned in total for this subject
      def items_learned_count_for(subject)
        learnings.for(subject).not_deferred.count
      end
  
      # How many items do I have left to learn for this subject today
      def items_left_to_learn_for(subject)
        daily_units - learnings.for(subject).not_deferred.today.count
      end
  
      # How far am I through this subject's curriculum
      def percent_learned_for(subject)
        learnings.for(subject).not_deferred.count.to_f / subject.units.count * 100
      end

      # Get the association for this unit
      def association_for(unit)
        (a = associations.for(unit).first) ? a : associations.build(:unit => unit, :body => 'Enter a hint here that will help you make an association between this question and its answer')
      end
      
      # Get the next unit to learn for this subject
      def next_unit_to_learn_for(subject)
        subject.units.not_learned_by(self).ordered.clean(:first)
      end
    end
  end
end