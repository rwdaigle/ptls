require 'common/workflow'

class LearningsController < ApplicationController
  
  include Ptls::Workflow

  before_filter :expose_subject_from_unit, :only => [:new, :create]
  before_filter :expose_subject_from_learning, :only => [:edit, :update, :review]
    
  make_resourceful do
    
    belongs_to :unit, :subject
    actions :edit, :update, :new, :create, :today, :review
    
    response_for :create, :defer do |wants|
      wants.html { redirect_to_next_learning }
    end
    
    response_for :today_complete do |wants|
      wants.html do
        flash[:notice] = "You've finished going through today's new material"
        redirect_to subject_path(@subject)
      end
    end
  end
  
  def new
    @learning = current_user.learnings.new(:unit => @unit)
  end
  
  def create
    @learning = current_user.learnings.create(object_parameters)
    @learning.deferred? ? response_for(:defer) : response_for(:create)
  end
  
  def review
    current_object.update_attributes(object_parameters)
    redirect_to today_subject_learnings_path(@subject, :page => (params[:page].to_i + 1))
  end
    
  # Iterate through today's newly learned items
  def today
    @learnings = current_user.learnings_for(@subject).paginate(:select => 'learnings.*', :page => params[:page], :per_page => 1)
    response_for(@learnings.empty? ? :today_complete : :today)
  end
  
  private
  
  def parent_object
    @parent_object ||=
      parent_model == Subject ?
        parent_model.find_by_permalink(params["#{parent_name}_id"]) :
        parent_model.find(params["#{parent_name}_id"])
  end
  
  def expose_subject_from_learning
    @subject = current_object.subject
  end

  def expose_subject_from_unit
    @subject = parent_object.subject
  end
end
