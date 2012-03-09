require 'common/workflow'

class ReviewsController < ApplicationController
  
  include Ptls::Workflow

  before_filter :expose_subject_from_review, :only => [:edit, :update, :review]
  
  include ActionView::Helpers::UrlHelper
  
  make_resourceful do
    
    belongs_to :subject
    
    actions :edit, :update, :missed, :shift
    
    response_for :update do |wants|
      wants.html { redirect_to_next_review }
    end
    
    response_for :missed_complete do |wants|
      wants.html do
        flash[:notice] = "You've finished going through the reviews that you missed during today's review cycle. " +
                         "<a href=\"#{missed_subject_reviews_path(@subject)}\">Click here</a> if you would like to do so again."
        redirect_to subject_path(@subject)
      end
    end
    
    response_for :shift do |wants|
      wants.html do
        flash[:notice] = "Your reviews have been successfully shifted."
        redirect_to subjects_path
      end
    end
  end

  def review
    current_object.update_attributes(object_parameters)
    redirect_to missed_subject_reviews_path(@subject, :page => (params[:page].to_i + 1))
  end
  
  # Iterate through reviews that were missed during today's review cycle
  def missed
    @reviews = current_user.missed(@subject).paginate(:select => 'reviews.*', :page => params[:page], :per_page => 1)
    response_for(@reviews.empty? ? :missed_complete : :missed)
  end
  
  def shift
    current_user.shift_reviews
    response_for :shift
  end
  
  # Need to get subject by permalink
  def parent_object
    @parent_object ||= parent_model.find_by_permalink(params["#{parent_name}_id"])
  end
  
  private
  
  def expose_subject_from_review
    @subject = current_object.subject
  end
end
