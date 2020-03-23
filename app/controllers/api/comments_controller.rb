class Api::CommentsController < ApplicationController
  def create
    @comment = Comment.new(comment_params)

    if @comment.text.blank? || @comment.post_id.blank? ||@comment.user_id.blank?
      response_bad_request
    elsif @comment.save
      response_success('コメントの投稿')
    else
    response_internal_server_error
    end
  end

  def show 
    @post = Post.find_by(id: params[:id])
    @comments = @post.comments.all
    @user = []
    @comments.each do |comment|
      user = User.find_by(id: comment.user_id)
      @user.push(user)
    end
    render json: {comments: @comments, users: @user}
    end

  private
  def comment_params
    params.require(:comment).permit(:text, :post_id, :user_id)
  end
end
