class PostsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]
  before_action :set_post, only: %i[edit update destroy]

  def index
    sort_option = params[:sort]
    @posts = Post.sort_posts(sort_option, params[:page]).visible

    if params[:tag_name]
      @tags = Post.tagged_with("#{params[:tag_name]}").page(params[:page])
    end
  end

  def show
    @post = Post.find(params[:id])
    @tags = @post.tag_counts_on(:tags)
    @comments = @post.comments.includes(:user).order(created_at: :desc)
    @comment = Comment.new
  end

  def new
    @post = Post.new
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
    params[:post][:images].drop(1).map{|id| ActiveStorage::Blob.find(id)} if params[:post][:images]
  end

  def create_blob(file)
    ActiveStorage::Blob.create_and_upload!(
      io: file.open,
      filename: file.original_filename,
      content_type: file.content_type
    )
  end
end
