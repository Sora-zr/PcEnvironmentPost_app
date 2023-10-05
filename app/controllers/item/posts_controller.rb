class Item::PostsController < ApplicationController
  before_action :set_post, only: %i[edit update destroy]

  def index
    @posts = Item::Post.includes(:user).order(created_at: :desc).page(params[:page])
    if params[:tag_name]
      @posts = Item::Post.tagged_with("#{params[:tag_name]}")
    end
  end

  def show
    @post = Item::Post.find(params[:id])
    @comments = @post.item_comments.includes(:user)
    @comment = current_user.item_comments.new
    @tags = @post.tag_counts_on(:tags)
  end

  def new
    @post = Item::Post.new
  end

  def create
    @post = current_user.item_posts.new(post_params)

    if @post.save
      redirect_to item_posts_url, success: '投稿が完了しました'
    else
      flash.now[:danger] = '投稿に失敗しました'
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @post.update(post_params)
      redirect_to item_post_url(@post), success: '更新が完了しました'
    else
      flash.now[:notice] = '更新に失敗しました'
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy!
    redirect_to item_posts_url, success: '投稿を削除しました'
  end

  private

  def post_params
    params.require(:item_post).permit(:name, :description, :tag_list)
  end

  def set_post
    @post = current_user.item_posts.find(params[:id])
  end
end
