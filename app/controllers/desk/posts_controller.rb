class Desk::PostsController < ApplicationController
  before_action :set_post, only: %i[edit update destroy]

  def index
    @posts = Desk::Post.includes(:user).order(created_at: :desc).page(params[:page]).per(15)
  end

  def show
    @post = Desk::Post.find(params[:id])
    @comments = @post.desk_comments.includes(:user)
    @comment = current_user.desk_comments.new
  end

  def new
    @post = Desk::Post.new
  end

  def create
    @post = current_user.build_desk_post(post_params)
    @post.image.attach(params[:desk_post][:image])

    if @post.save
      redirect_to desk_posts_url, success: '投稿が完了しました'
    else
      flash.now[:danger] = '投稿できませんでした'
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    @post.image.attach(params[:desk_post][:image]) if @post.image.blank?

    if @post.update(post_params)
      redirect_to desk_post_url(@post), success: '更新が完了しました'
    else
      flash.now[:danger] = '更新できませんでした'
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy!
    redirect_to desk_posts_url, status: :see_other
  end

  private

  def post_params
    params.require(:desk_post).permit(:title, :description, :image)
  end

  def set_post
    @post = current_user.desk_post
  end
end
