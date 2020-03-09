class Api::FavoritesController < ApplicationController
  def index
    @favorites = current_user.favorite_posts.all.oreder(created_at: :desc)
    render json: @favorites
    
      end
    
      def create
    @favorite = Favorite.new(favorite_params)
    @favorite.user_id = current_user.id
    
    if @favorite.user_id.blank? || @favorite.post_id.blank?
      response_bad_request
    elsif
      @favorite.save
      response_success(:favorite, :create)
    else
      response_internal_server_error
    end
    
      end
    
      def destroy
        @favorite = Favorite.find_by(user_id: current_user.id, post_id: favorite_params)
        if @favolite.destroy
          response_success(:favorite, :destroy)
        else
          response_internal_server_error
        end
      end
    
    private
    def favorite_params
      params.require(:favorite).permit(:post_id)
    end
end
