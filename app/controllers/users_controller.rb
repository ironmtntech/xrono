class UsersController < ApplicationController
  before_filter :load_user, :only => [:show, :edit, :change_password, :historical_time, :update, :accounts]
  skip_before_filter :redirect_clients

  access_control do
    allow :admin
    allow :developer, :to => [:edit, :change_password, :update], :if => :user_is_current_user?
    allow :developer, :to => [:index, :show, :historical_time]
    allow :client, :to => [:edit, :show, :change_password], :if => :user_is_current_user?
  end

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
      sign_in(@user, :bypass => true)
      flash[:notice] = t(:password_updated_successfully)
      redirect_to :action => :show
    else
      params[:user][:password] = params[:user][:password_confirmation] = ''
      flash.now[:error] = t(:password_updated_unsuccessfully)
      render :edit
    end
  end

  def historical_time
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:notice] = t(:user_updated_successfully)
      redirect_to @user
    else
      flash.now[:error] = t(:user_updated_unsuccessfully)
      render :action => 'edit'
    end
  end

  def accounts
  end

  def redeem_remote_day
  end

  def submit_remote_day
    remote_workday_request = RemoteWorkdayRequest.new(date_requested: params[:date], user_id: current_user.id, state: "incomplete")
    if remote_workday_request.save
      flash[:notice] = "Your request has been submitted"
    else
      flash[:error] = "There was an error processing your request, please try again or contact an admin"
    end
    redirect_to :back
  end

  private
  def load_user
    @user = User.find(params[:id])
  end

  def user_is_current_user?
    @user == current_user
  end
end
