class UsersController < ApplicationController

  before_action :logged_in_user, except: [:create, :show, :new]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy
  before_action :find_user, except: [:create, :new, :index]

  def index
    @users = User.paginate page: params[:page]
  end

  def show
    @microposts = @user.microposts.order_by_day.paginate page: params[:page]
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t "please_check_your_email_to_active"
      redirect_to root_url
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update_attributes user_params
      flash[:success] = t "profile_updated"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    flash[:success] = t "user_deleted"
    redirect_to users_url
  end

  def following
    @title = t "following"
    @user = User.find_by id: params[:id]
    if @user.nil?
      render :error
    end
    @users = @user.following.paginate page: params[:page]
    render :show_follow
  end

  def followers
    @title = t "followers"
    @user  = User.find_by id: params[:id]
    if @user.nil?
      render :error
    end
    @users = @user.followers.paginate page: params[:page]
    render :show_follow
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password, :password_confirmation
  end

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = t "please_log_in"
      redirect_to login_url
    end
  end

  def correct_user
    @user = User.find_by id: params[:id]
    redirect_to root_url unless current_user? @user
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end

  def find_user
    @user = User.find_by id: params[:id]
    if @user.nil?
      render :error
    end
  end
end
