class Item::LikesController < ApplicationController
  def create
    @post = Item::Post.find(params[:item_post_id])
    current_user.like(@post)
  end

  def destroy
    @post = current_user.item_likes.find(params[:id]).item_post
    current_user.unlike(@post)
  end
end
