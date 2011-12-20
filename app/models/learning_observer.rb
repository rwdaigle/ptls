class LearningObserver < ActiveRecord::Observer
  def after_create(learning)
    Review.create_from(learning)
  end
end