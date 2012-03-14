require 'common/workflow'

class SubjectsController < ApplicationController
  
  include Ptls::Workflow
    
  before_filter :expose_subject
  before_filter :force_seed, :only => :quiz
  
  make_resourceful do
    
    actions :all, :review, :learn, :quiz
    
    response_for :index do |wants|
      wants.html do
        if(@subjects.size > 1)
          render :layout => 'bare'
        else
          redirect_to subject_path(@subjects.first) if @subjects.size == 1
        end
      end
    end
    
    response_for :quiz_complete do |wants|
      wants.html do
        flash[:notice] = "You've finished going through all items you've ever learned in this subject!"
        redirect_to subject_path(@subject)
      end
    end
      
  end
  
  def index
    load_objects
    before :index
    response_for :index
  end
    
  
  def quiz
    @subject = current_object
    Subject.seedRandom(params[:seed])
    @units = @subject.units.learned_by(current_user).random.paginate(:page => params[:page], :per_page => 1).all
    @units.empty? ? response_for(:quiz_complete) : response_for(:quiz)
  end
  
  def learn; redirect_to_next_learning end
    
  def review; redirect_to_next_review; end

  private
  
  def force_seed
    redirect_to quiz_subject_path(current_object, :page => (params[:page] || 1), :seed => rand()) if
      params[:seed].blank?    
  end
  
  def current_object
    @current_object ||= if plural?
      current_model.find_by_permalink(params[:id])
    else
      parent_object.send(instance_variable_name)
    end
  end
  
  def expose_subject
    @subject = current_object
  end
    
end
