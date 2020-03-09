class Api::PostsController < ApplicationController
  before_action :set_post, only: [:show, :update, :destroy]
  def index
    @posts = Post.all.order(created_at: :desc)
    render json: @posts
  end

  def create
    @post = Post.new(post_params)
    if @post.text.blank?
      response_bad_request
    elsif @post.save
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
      esponse_internal_server_error
    end
  end


  private
  def set_post
    @post = Post.find_by(id: params[:id])
    response_not_found(:post) if @post.blank?
  end

  def post_params
    params.require(:post).permit(:text, pictures_attributes: [:image, :video, :id, :user_id, :post_id])
  end
end
