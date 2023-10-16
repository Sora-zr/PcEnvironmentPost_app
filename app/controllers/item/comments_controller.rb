class Item::CommentsController < ApplicationController
  def create
    @comment = current_user.item_comments.build(comment_params)
    @comment.save
  end

  def destroy
    @comment = current_user.item_comments.find(params[:id])
    @comment.destroy!
  end

  private

  def comment_params
    params.require(:item_comment).permit(:content, :item_post_id)
  end
end
