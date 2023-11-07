require 'rails_helper'

RSpec.describe Post, type: :model do
  it '入力値が全て正常であれば、有効となる' do
    post = FactoryBot.build(:post)
    expect(post).to be_valid
  end

  it '説明文を入力しなかった場合、無効となる' do
    post = FactoryBot.build(:post, description: nil)
    expect(post).not_to be_valid
  end

  it '画像を入力しなかった場合、無効となる' do
    post = FactoryBot.build(:post)
    post.images.purge
    expect(post).not_to be_valid
  end

  it '有効なフォーマットの画像でない場合、無効となる' do
    post = FactoryBot.build(:post)
    post.images.attach(io: File.open('spec/fixtures/not_format_image.gif'), filename: 'not_format_image.gif')
    expect(post).not_to be_valid
  end

  it '画像の容量が5MBを超えた場合、無効となる' do
    post = FactoryBot.build(:post)
    post.images.attach(io: File.open('spec/fixtures/10MB_image.jpg'), filename: '10MB_image.jpg')
    expect(post).not_to be_valid
  end

  it '画像の枚数が8枚を超えた場合、無効となる' do
    post = FactoryBot.build(:post)
    10.times do
      post.images.attach(io: File.open('spec/fixtures/test_image.jpg'), filename: 'test_image.jpg')
    end
    expect(post).not_to be_valid
  end
end
