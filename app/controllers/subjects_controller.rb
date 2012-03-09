class SubjectsController < ApplicationController

  make_resourceful do
    actions :index, :show
  end

  private

  def current_object
    @current_object ||= current_model.find_by_permalink(params[:id])
  end
end
