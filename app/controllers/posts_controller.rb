class PostsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]
  before_action :set_post, only: %i[edit update destroy]

  def index
    sort_option = params[:sort]
    @search = Post.ransack(params[:q])
    @posts = @search.result(distinct: true).sort_posts(sort_option, params[:page]).visible
    @new_posts = Post.includes(:user).order(created_at: :desc).visible.limit(2)

    # タグ絞り込み
    if params[:tag]
      @posts = Post.tagged_with("#{params[:tag]}").sort_posts(sort_option, params[:page]).visible
    end
  end

  def show
    @post = Post.find(params[:id])
    @tags = @post.tag_counts_on(:tags)
    @items = @post.items
    @comments = @post.comments.includes(:user).order(created_at: :desc)
    @comment = Comment.new

    # おすすめの投稿
    if user_signed_in?
      @recommended_posts = Post.recommended_for_user(current_user)
    end
  end

  def new
    if current_user.post.present?
      redirect_to posts_url, alert: 'すでに投稿済みです。'
    else
      @post = Post.new
      @items = []
      if params[:item]
        @item = params[:item]
      end
    end
  end

  def create
    @post = current_user.build_post(post_params)

    if @post.save
      redirect_to posts_url, notice: t('.success')
    else
      flash.now[:alert] = t('.failure')
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @post.update(post_params)
      redirect_to post_url(@post), notice: t('.success')
    else
      flash.now[:alert] = t('.failure')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy!
    redirect_to posts_url, notice: t('.success')
  end

  def diagnose
    @diagnose_posts = Post.diagnose(params)
  end

  def bookmarks
    @post_bookmarks = current_user.post_bookmarks.includes(:user).order(created_at: :desc).page(params[:page]).visible
  end

  def upload_image
    @image_blob = create_blob(params[:image])
    render json: @image_blob
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:description, :tag_list).merge(images: uploaded_images)
  end

  def uploaded_images
    params[:post][:images].drop(1).map { |id| ActiveStorage::Blob.find(id) } if params[:post][:images]
  end

  def create_blob(file)
    ActiveStorage::Blob.create_and_upload!(
      io: file.open,
      filename: file.original_filename,
      content_type: file.content_type
    )
  end
end
