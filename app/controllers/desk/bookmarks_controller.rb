class Desk::BookmarksController < ApplicationController
  def create
    @post = Desk::Post.find(params[:desk_post_id])
    current_user.bookmark(@post)
    redirect_back fallback_location: root_url
  end

  def destroy
    @post = current_user.desk_bookmarks.find(params[:id]).desk_post
    current_user.unbookmark(@post)
    redirect_back fallback_location: root_url
  end
end
