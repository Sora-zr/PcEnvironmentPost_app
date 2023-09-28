class Item::BookmarksController < ApplicationController
  def create
    @post = Item::Post.find(params[:item_post_id])
    current_user.bookmark(@post)
    redirect_back fallback_location: root_url
  end

  def destroy
    @post = current_user.item_bookmarks.find(params[:id]).item_post
    current_user.unbookmark(@post)
    redirect_back fallback_location: root_url
  end
end
