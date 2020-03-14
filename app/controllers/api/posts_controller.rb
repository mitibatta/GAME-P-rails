class Api::PostsController < ApplicationController
  before_action :set_post, only: [:show, :update, :destroy]
  def index
    @posts = Post.all.order(created_at: :desc)
    @posts.each do |post|
      @user = post.user.name
      @image = post.pictures.image
      @video = post.pictures.video
    end
    render json: {posts: @posts, user: @user, image: @image, video: @video}
    # render json: @posts
  end

  # def new
  #   @post = Post.new
  #   @post.pictures.build
  # end

  def create
    @post = Post.new(post_params)
    @post.pictures.build(image: params[:post][:image], video: params[:post][:video], user_id: params[:post][:user_id])
    @post.pictures.each do |picture|
      picture.post_id = @post.id
    end
    if @post.text.blank?
      response_bad_request
    elsif @post.save!
      response_success(:post, :create)
    else
      response_internal_server_error
    end
  end

  def show
    render json: @post
  end

  def update
    if @post.text.blank?
      response_bad_request
    elsif @post.update
      response_success(:post, :update)
    else
      response_internal_server_error
    end
  end

  def destroy
    if @post.destroy
      response_success(:post, :destroy)
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
