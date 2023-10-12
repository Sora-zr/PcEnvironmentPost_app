class Desk::LikesController < ApplicationController
  def create
    @post = Desk::Post.find(params[:desk_post_id])
    current_user.like(@post)
    redirect_back fallback_location: root_url
  end

  def destroy
    @post = current_user.desk_likes.find(params[:id]).desk_post
    current_user.unlike(@post)
    redirect_back fallback_location: root_url
  end
end
