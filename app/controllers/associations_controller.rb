#TODO: remove reliance on prototype for remote_form_for
class AssociationsController < ApplicationController
    
  make_resourceful do
    
    actions :create, :edit, :update, :destroy
    
    response_for :create, :update, :destroy, :create_fails, :update_fails, :destroy_fails do |wants|
      wants.js { render :action => :update }
    end

    response_for :edit do |wants|
      wants.js
    end
  end
  
  def build_object
    @current_object ||= current_user.associations.build(object_parameters)
  end
  
  def current_object
    @current_object ||= current_user.associations.find(params[:id])
  end    
end
