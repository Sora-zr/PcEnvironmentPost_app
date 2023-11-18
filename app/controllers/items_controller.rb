class ItemsController < ApplicationController
  before_action :authenticate_user!

  def new
    @items = []

    if params[:keyword]
      results = RakutenWebService::Ichiba::Product.search(keyword: params[:keyword])
      results.each do |result|
        item = Item.new(read(result))
        @items << item
      end
    end
  end

  def create
    @item = current_user.post.items.build(brand_name: params[:brand_name], item_name: params[:item_name], image_url: params[:image_url], item_url: params[:item_url], price: params[:price])
    if current_user.post.items.count >= 8
      redirect_to post_path(current_user.post), alert: '投稿には最大で8個までのアイテムしか登録できません。'
    else
      if @item.save
        redirect_to post_url(current_user.post)
      else
        render :new
      end
    end
  end

  def destroy
    item = current_user.post.items.find(params[:id])
    item.destroy!
    redirect_back fallback_location: root_url, notice: '削除しました。'
  end

  private

  def read(result)
    brand_name = result['brandName']
    item_name = result['productName']
    image_url = result['mediumImageUrl']
    item_url = result['productUrlPC']
    price = result['averagePrice']
    {
      brand_name: brand_name,
      item_name: item_name,
      image_url: image_url,
      item_url: item_url,
      price: price
    }
  end
end
