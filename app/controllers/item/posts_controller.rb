class Item::PostsController < ApplicationController
  before_action :set_post, only: %i[edit update destroy]

  def index
    @posts = Item::Post.includes(:user).order(created_at: :desc)
  end

  def show
    @post = Item::Post.find(params[:id])
    @comments = @post.item_comments.includes(:user)
    @comment = current_user.item_comments.new
  end

  def new
    @post = Item::Post.new
  end

  def create
    @post = current_user.item_posts.new(post_params)

    if @post.save
      redirect_to item_posts_url
    else
      render :new
    end
  end

  def edit; end

  def update
    if @post.update(post_params)
      redirect_to item_post_url(@post)
    else
      render :edit
    end
  end

  def destroy
    @post.destroy!
    redirect_to item_posts_url
  end

  private

  def post_params
    params.require(:item_post).permit(:name, :description)
  end

  def set_post
    @post = current_user.item_posts.find(params[:id])
  end
end
