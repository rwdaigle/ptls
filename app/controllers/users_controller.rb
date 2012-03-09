class UsersController < ApplicationController
  
  skip_before_filter :login_required, :only => [:new, :create]
  layout 'bare'

  # render new.rhtml
  def new
    @user = User.new
  end
  
  def edit
    @user = current_user
  end
  
  def update
    @user = current_user
    if @user.update_attributes(params[:user])
      flash[:notice] = "Your profile has been saved"
      redirect_to edit_user_path(@user)
    else
      render :action => 'edit'
    end
  end

  def create
    cookies.delete :auth_token
    # protects against session fixation attacks, wreaks havoc with 
    # request forgery protection.
    # uncomment at your own risk
    # reset_session
    @user = User.new(params[:user])
    @user.save
    if @user.errors.empty?
      self.current_user = @user
      redirect_back_or_default(subjects_path)
      flash[:notice] = "Thanks for signing up!"
    else
      render :action => 'new'
    end
  end

end
