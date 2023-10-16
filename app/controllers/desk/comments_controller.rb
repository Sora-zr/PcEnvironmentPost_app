class Desk::CommentsController < ApplicationController
  def create
    @comment = current_user.desk_comments.build(comment_params)
    @comment.save
  end

  def destroy
    @comment = current_user.desk_comments.find(params[:id])
    @comment.destroy!
  end

  private

  def comment_params
    params.require(:desk_comment).permit(:content, :desk_post_id)
  end
end
