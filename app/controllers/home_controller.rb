class HomeController < ApplicationController
  skip_before_action :authenticate_user!

  def top
    @item_posts = Item::Post.all
    @desk_posts = Desk::Post.all
  end
end
