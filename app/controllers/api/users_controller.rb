class Api::UsersController < ApplicationController
  before_action :set_user, only: :show
  def create
    @user = User.new(user_params)
    # if @user.name.blank? || @user.email.blank? ||@user.password.blank? || @user.password_confirmation.blank?
    #   response_bad_request
    # if User.exists?(email: @user.email)
    #   response_conflict(:user)
    if @user.save
      response_success(:user, :create)
    else
    response_internal_server_error
    end
  end

  def show
    @post = @user.posts.all.order(created_at: :desc)
    render json: @post
  end

  private
  def set_user
    @user = User.find_by(id: params[:id])
    response_not_found(:user) if @user.blank?
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

end

