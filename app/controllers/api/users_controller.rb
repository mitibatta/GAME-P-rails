class Api::UsersController < ApplicationController
  before_action :set_user, only: :show
  
  def create
    @user = User.new(user_params)
    if @user.name.blank? || @user.email.blank? ||@user.password_digest.blank?
      response_bad_request
    elsif User.exists?(email: @user.email)
      response_conflict(:user)
    elsif @user.save
      response_success('アカウント作成')
    else
    response_internal_server_error
    end
  end

  def show
    @posts = @user.posts.all.order(created_at: :desc)
    @pictures = []
    @favorites = Favorite.all
    @posts.each do |post|
      pic = Picture.find_by(post_id: post.id)
      @pictures.push(pic)
    end
    render json: {user: @user, posts: @posts, pictures: @pictures, favorites: @favorites}
  end

  private
  def set_user
    @user = User.find_by(id: params[:id])
    response_not_found(:user) if @user.blank?
  end

  def user_params
    params.require(:user).permit(:name, :email, :password_digest)
  end

end

