class Api::FavoritesController < ApplicationController
  def index
    @login_user = User.find_by(id: params[:id])
    @favorites = @login_user.favorite_posts.all.order(created_at: :desc)
    @favs = Favorite.all
    @pictures = []
    @users = []
    @favorites.each do |favorite|
      pic = Picture.find_by(post_id: favorite.id)
      @pictures.push(pic)
      @users.push(favorite.user)
    end
    render json: {posts: @favorites, pictures: @pictures, users: @users, favorites: @favs}
      end
  def indexUsers
    @user = User.find_by(id: params[:id])
    @post = @user.favorite_posts.all
    render json: @post
  end

  def count
    @post = Post.find_by(id: params[:id])
    @favorite = @post.favorites.all
    render json: @favorite.length
  end
      
      def create
    @favorite = Favorite.new(favorite_params)
    # @favorite.user_id = current_user.id
    
    if @favorite.user_id.blank? || @favorite.post_id.blank?
      response_bad_request
    elsif
      @favorite.save
      response_success('いいね')
    else
      response_internal_server_error
    end
    
      end
    
      def destroy
        @favorite = Favorite.find_by(favorite_params)
        if @favorite.destroy
          response_success('いいねの削除')
        else
          response_internal_server_error
        end
      end
    
    private
    def favorite_params
      params.require(:favorite).permit(:post_id, :user_id)
    end

    def post_params
      params.require(:favorite).permit(:user_id)
    end
end
