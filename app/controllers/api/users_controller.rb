class Api::UsersController < Api::ApiController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy,
                                        :following, :followers]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy
  def index
    @users = User.page(params[:page])
  end
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.page(params[:page])
  end
  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      render json: {
        flash: ["info", "Please check your email to activate your account."],
        user: @user
        # redirect_to root_url
      }
    else
      render json: { error: @user.errors.full_messages }
    end
  end
  def edit
    @user = User.find(params[:id])
    render json: {
      user: @user,
      gravatar: Digest::MD5::hexdigest(@user.email.downcase)
    }
  end
  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      render json: { flash_success: ["success", "Profile updated"] }
    else
      render json: { error: @user.errors.full_messages }
    end
  end
  def destroy
    User.find(params[:id]).destroy
    render json: { flash: ["success", "User deleted"] }
  end
  def following
    @user  = User.find(params[:id])
    @users = @user.following.page(params[:page])
    @xusers = @user.following
  end
  def followers
    @user  = User.find(params[:id])
    @users = @user.followers.page(params[:page])
    @xusers = @user.followers
  end
  private
    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
    # Before filters
    # Confirms the correct user.
    def correct_user
      @user = User.find(params[:id])
      render json: { flash: ["info", "User aren't Current User"] } unless current_user?(@user)
    end
    # Confirms an admin user.
    def admin_user
      render json: { flash: ["info", "Current User aren't Admin"] } unless current_user.admin?
    end
end
