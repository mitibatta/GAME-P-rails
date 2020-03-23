class Api::PostsController < ApplicationController
  before_action :set_post, only: [:show, :update, :destroy]
  def index
    @posts = Post.all.order(created_at: :desc)
    @user = User.all
    @picture = Picture.all
    @favorite = Favorite.all
    render json: {posts: @posts, users: @user, pictures: @picture, favorites: @favorite}
  end

  def create
    # binding.pry
    @post = Post.new(post_params)
    @post.pictures.build(image: params[:post][:image], video: params[:post][:video], user_id: params[:post][:user_id])
    @post.pictures.each do |picture|
      picture.post_id = @post.id
    end
    if @post.text.blank?
      response_bad_request
    elsif @post.save
      response_success("投稿")
    else
      response_internal_server_error
    end
  end

  def show
    @picture = Picture.find_by(post_id: params[:id])
    @favorites = @post.favorites
    @user = @post.user.name
    render json: {post: @post, picture: @picture, user: @user, favorites: @favorites}
  end

  def update
    if @post.text.blank?
      response_bad_request
    elsif @post.update(post_params)
      @post.pictures.update(image: params[:post][:image], video: params[:post][:video])
      response_success('投稿の更新')
    else
      response_internal_server_error
    end
  end

  def destroy
    if @post.destroy
      @pic = Picture.find_by(id: params[:id])
      @pic.destroy
      response_success('投稿の削除')
    else
      response_internal_server_error
    end
  end


  private
  def set_post
    @post = Post.find_by(id: params[:id])
    response_not_found(:post) if @post.blank?
  end

  def post_params
    params.require(:post).permit(:text, :user_id)
  end

  # def picture_params
  #   params.require(:post).permit(:image, :video, :user_id)
  # end
end
