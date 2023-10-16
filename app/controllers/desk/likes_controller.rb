class Desk::LikesController < ApplicationController
  def create
    @post = Desk::Post.find(params[:desk_post_id])
    current_user.like(@post)
  end

  def destroy
    @post = current_user.desk_likes.find(params[:id]).desk_post
    current_user.unlike(@post)
  end
end
