class Api::CommentsController < ApplicationController
  def create
    @comment = Comment.new(comment_params)
    @comment.user_id = current_user.id

    if @comment.text.blank? || @comment.post_id.blank? ||@comment.user_id.blank?
      response_bad_request
    elsif @comment.save
      response_success(:comment, :create)
    else
    response_internal_server_error
    end
  end

  private
  def comment_params
    params.require(:comment).permit(:text, :post_id)
  end
end
