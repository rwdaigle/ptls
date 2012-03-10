module SubjectsHelper
  
  def review_button(subject)
    if not current_user.review?(subject)
      image_tag('/images/review_button_done.png')
    else
      link_to(image_tag('/images/review_button.png'), review_subject_path(subject))
    end
  end
  
  def learn_button(subject)
    if not current_user.learn?(subject)
      image_tag('/images/learn_button_done.png')
    else
      link_to(image_tag('/images/learn_button.png'), learn_subject_path(subject))
    end
  end
  
  def show_instructions?
    current_user.learnings.count <= 0
  end
  
  def todays_review_callout(subject)
    if current_user.review?(subject)
      "You have #{content_tag(:em, current_user.items_left_to_review_for(subject))} items to review today."
    else
      "You've completed all reviews scheduled for today - " +
      "would you like to #{link_to('review the items you missed', missed_subject_reviews_path(subject))}?"
    end
  end
  
  def review_shift_callout
    if current_user.reviews_behind
      "(It appears that you are behind on your reviews.  #{link_to 'Click here', shift_reviews_path, :method => :put} to bring your reviews up-to-date so you don't have more than one days worth of reviews today.)"
    end
  end
  
  def todays_learning_callout(subject)
    if current_user.learn?(subject)
      "You have #{content_tag(:em, current_user.items_left_to_learn_for(subject))} new items to learn today."
    else
      "You've learned all new items scheduled for today - " +
      "would you like to #{link_to('review these items again', today_subject_learnings_path(subject))}?"
    end
  end
  
  def subject_progress(subject)
    "So far you have learned #{content_tag(:em, current_user.items_learned_count_for(subject))} items " +
    "meaning you are #{content_tag(:em, p(current_user.percent_learned_for(subject)))} complete with the curriculum."
  end
  
  def subject_retention(subject)
    "You have a #{content_tag(:em, p(current_user.retention(subject)))} retention rate.  " +
    "Anything above 90% is considered to be excellent while anything above 75% is still very good."
  end
  
  def remaining_quiz
    (count = @units.total_pages - @units.current_page) <= 0 ?
      "final item" :
      "#{count} remaining"
  end
  
  def next_quiz_link
    quiz_subject_path(@subject, :page => (@units.current_page + 1), :seed => params[:seed])
  end
end