module UnitsHelper
  
  def hint_bar_for(unit)
    link_to_function(image_tag('hint.png'),
      "$('#hint').toggleHint();", :id => 'hint_tab', :key => 'h') +
      render(:partial => '/associations/association', :locals => { :association => current_user.association_for(unit) })
  end  
  
  def remaining_reviews
    (count = current_user.items_left_to_review_for(@subject) - 1) <= 0 ?
      "final item" :
      "#{count} remaining"
  end
  
  def remaining_missed_reviews(current_item)
    (count = current_user.missed(@subject).count - current_item) <= 0 ?
      "final item" :
      "#{count} remaining"
  end
  
  def remaining_learnings
    (count = current_user.items_left_to_learn_for(@subject) - 1) <= 0 ?
      "final item" :
      "#{count} remaining"
  end
  
  def remaining_todays_review
    (count = @learnings.total_pages - @learnings.current_page) <= 0 ?
      "final item" :
      "#{count} remaining"
  end
  
  def remaining_todays_learnings
    (count = (current_user.items_left_to_learn_for(@subject))) <= 1 ?
      "final item" :
      "#{count} remaining"
  end
end
