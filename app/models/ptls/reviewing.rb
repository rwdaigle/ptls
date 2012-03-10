module Ptls
  module User
    module Reviewing
  
      # Have I started reviewing items yet?
      def reviewing_yet?(subject)
        reviews.for(subject).reviewed.count > 0
      end
  
      # Do I have anything new to review for today?
      def review?(subject)
        items_left_to_review_for(subject) > 0
      end
  
      # How many items do I have left to review today?
      def items_left_to_review_for(subject)
        reviews.for(subject).today.left.count
      end
  
      # Get the next review due up for this subject
      def review(subject)
        reviews.for(subject).today.left.clean(:first)
      end
  
      # What is my retention percent
      def retention(subject)
        reviewed = reviews.for(subject).reviewed.count
        reviewed > 0 ?
          reviews.for(subject).successful.count.to_f / reviewed * 100 :
          0
      end
  
      # Get the reviews that I missed today
      def missed(subject)
        reviews.for(subject).reviewed_today.failed
      end
      
      def reviews_behind
        review_days_behind > 0
      end
    
      # How many days behind is this user with their reviews
      def review_days_behind
        # Get the oldest unreviewed review
        oldest = reviews.left.first
        oldest ? (Time.zone.today - oldest.scheduled_at.to_date).to_i : 0
      end
    
      # If this user has missed their reviews for a number of days, shift them
      # all so they're not behind
      def shift_reviews
        if((days_behind = review_days_behind) > 0)
          Review.update_all("scheduled_at = scheduled_at + INTERVAL '#{days_behind} days'")
        end
      end
    end
  end
end