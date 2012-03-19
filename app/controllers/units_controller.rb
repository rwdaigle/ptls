class UnitsController < ApplicationController

  before_filter :expose_subject_from_unit, :except => :queue
  before_filter :ensure_ownership, :only => [:edit_question, :edit_answer, :update, :destroy]
  
  make_resourceful do
    actions :all, :edit_question, :queue
    belongs_to :subject
    
    response_for :create do |wants|
      wants.html { redirect_to subject_unit_path(@subject, @unit) }
    end
    
    response_for :update, :edit_question, :edit_answer do |wants|
      wants.js
    end
    
    response_for :destroy do |wants|
      wants.html do
        flash[:notice] = "The requested item has been deleted"
        redirect_to @subject
      end
    end
    
    response_for :destroy_fails do |wants|
      wants.html do
        flash[:notice] = "The requested item could not be deleted"
        redirect_to @subject
      end
    end
  end
  
  def edit_question
    load_object
  end
  
  def edit_answer
    load_object
  end
  
  def update_question
    load_object
    current_object.update_attributes object_parameters
    response_for :update_question
  end

  def queue
    logger.info "[UnitsController] event=queue subject_id=#{parent_object.id} subject=\"#{parent_object}\""
    $queue.enqueue('Subject.process!', parent_object.id)
    flash[:notice] = "#{parent_object} has been queued for processing of empty units."
    redirect_to parent_object
  end
  
  # Need to get subject by permalink
  def parent_object
    @parent_object ||= parent_model.find_by_permalink(params["#{parent_name}_id"])
  end
  
  private

  def expose_subject_from_unit
    @subject = current_object.subject
  end
  
  def ensure_ownership
    if not current_user.owns?(@subject)
      flash[:error] = "You are not allowed to edit that item.  You can only edit items in subjects that you've created."
      redirect_to @subject
    end
  end
end
