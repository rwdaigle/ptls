module Ptls
  module Workflow
    
    # Given a logged in user, handle determining the navigation
    # to their next unit to learn
    def redirect_to_next_learning
      next_unit = current_user.next_unit_to_learn_for(@subject) if current_user.items_left_to_learn_for(@subject) > 0
      if next_unit
        redirect_to new_unit_learning_path(next_unit)
      else
        flash[:notice] = "You've completed all the new #{@subject} material scheduled for today.  Great job!"
        redirect_to subject_path(@subject)
      end
    end
    
    # Handle determining the navigation to their next
    # item to review
    def redirect_to_next_review
      @review = current_user.review(@subject)
      if @review
        redirect_to edit_review_path(@review)
      else
        flash[:notice] = "You've completed all the #{@subject} reviews scheduled for today.  Great job!"
        redirect_to subject_path(@subject)
      end
    end
  end
end