require 'rails_helper'

RSpec.describe User, type: :model do
  it '入力値が全て正常であれば、有効となる' do
    user = FactoryBot.build(:user)
    expect(user).to be_valid
  end

  it 'ユーザー名を入力しなかった場合、無効となる' do
    user = FactoryBot.build(:user, name: nil)
    expect(user).not_to be_valid
  end

  it 'メールアドレスを入力しなかった場合、無効となる' do
    user = FactoryBot.build(:user, email: nil)
    expect(user).not_to be_valid
  end

  it 'メールアドレスが重複した場合、無効となる' do
    User.create(name: 'test', email: 'test@exsample.com', password: 'password')
    user = FactoryBot.build(:user, email: 'test@exsample.com')
    expect(user).not_to be_valid
  end

  it 'パスワードを入力しなかった場合、無効となる' do
    user = FactoryBot.build(:user, password: nil)
    expect(user).not_to be_valid
  end

  it 'パスワードが5文字以内だった場合、無効となる' do
    user = FactoryBot.build(:user, password: 'pass')
    expect(user).not_to be_valid
  end
end
