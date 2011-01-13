class UsersController < ApplicationController
  before_filter :load_user, :only => [:show, :edit, :change_password, :historical_time]
  before_filter :require_current_user, :only => [:edit, :change_password]

  def index
    @users = User.unlocked.sort_by_name
  end

  def show
  end

  def edit
  end

  def change_password
    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]
    if @user.save
      flash[:notice] = t(:password_updated_successfully)
      redirect_to :action => :show
    else
      params[:user][:password] = params[:user][:password_confirmation] = ''
      flash.now[:error] = t(:password_updated_unsuccessfully)
      render :action => :edit
    end
  end

  def historical_time
  end

  protected

    def load_user
      @user = User.find(params[:id])
    end

    def require_current_user
      unless @user == current_user
        flash[:error] = t(:cannot_make_changes_to_another_user)
        redirect_to dashboard_path
      end
    end
end
