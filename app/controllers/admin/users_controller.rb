class Admin::UsersController < Admin::BaseController
  before_filter :load_user_account, :only => [:update, :edit, :destroy, :projects]
  before_filter :load_new_user_account, :only => [:new, :create]
  before_filter :filter_blank_password, :only => [:update]

  def index
    # This is extremely inefficient but we won't have enough users for this
    # in-memory sort to matter
    @users = User.unlocked.sort_by_name.select{|u| !u.client? }
  end

  def locked_users
    @users = User.locked.sort_by_name.select{|u| !u.client? }
  end

  def unlocked_clients
    @users = User.unlocked.sort_by_name.select{|u| u.client? }
  end

  def locked_clients
    @users = User.locked.sort_by_name.select{|u| u.client? }
  end

  def new
  end

  def create
    params[:user].delete(:locked) if params[:user][:locked].present?
    @user.update_attributes(params[:user])
    if params[:user]["client"] == "1"
      @user.client = true
    end
    if @user.save
      flash[:notice] = t(:user_created_successfully)
      redirect_to admin_users_path
    else
      flash[:error] = t(:user_created_unsuccessfully)
      redirect_to new_admin_user_path
    end
  end

  def edit
  end

  def update
    params[:user]["locked"] == "1" ? @user.lock_access! : @user.unlock_access!
    params[:user].delete(:locked) if params[:user][:locked].present?

    @user.update_attributes(params[:user])
    if @user.save
      flash[:notice] = t(:user_updated_successfully)
      redirect_to user_path(@user)
    else
      flash[:error] = t(:user_updated_unsuccessfully)
      redirect_to edit_admin_user_path(@user)
    end
  end

  def projects
    if request.post?
      params[:project].each do |key, value|
        project = Project.find(key.to_i)
        role = value.to_sym
        @user.has_no_roles_for!(project)
        @user.has_role!(role, project) unless role == :no_access
      end
      flash[:notice] = t(:roles_updated_successfully)
      redirect_to admin_users_path
    end
  end

  private

  def filter_blank_password
    if params[:user]["password"] == "" && params[:user]["password_confirmation"] == ""
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end
  end

  def load_user_account
    @user = User.find(params[:id])
  end

  def load_new_user_account
    @user = User.new
  end
end
